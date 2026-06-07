require('dotenv').config({
  path: __dirname + '/.env'
});
const cds = require("@sap/cds");
const { Readable } = require('node:stream');
const { buffer: streamToBuffer } = require('node:stream/consumers');
const { uploadImage, downloadImage, deleteImage } = require('./lib/dropbox');
const { SELECT } = require('@sap/cds/lib/ql/cds-ql');
const { register } = require('node:module');

const isStream = (v) => v && (typeof v.pipe === 'function' || typeof v[Symbol.asyncIterator] === 'function');


module.exports = class ProductsService extends cds.ApplicationService {

    init () {

        const {Products, Inventories} = this.entities;
        

        //before
        //on --> Cloud / On-P
        //after

        this.before('NEW', Products.drafts, async (req) => {
            req.data.detail??= {
                baseUnit: 'EA',
                width: null,
                height: null,
                depth: null,
                weight: null,
                unitVolume: 'CM',
                unitWeight: 'KG'
            };
            console.log(req.data);
        });

        this.before(['CREATE', 'UPDATE'], Products, async (req) => {
            const incoming = req.data.image;
            if (incoming === undefined) return;

            const ID = req.data.ID || req.params?.[0]?.ID;

            if (incoming === null) {
                const prev = await SELECT.one.from(Products).columns('fileName').where({ ID });
                if (prev?.fileName) await deleteImage(prev.fileName);
                req.data.fileName = null;
                req.data.image = null;
                return;
            }

            const buf = Buffer.isBuffer(incoming) ? incoming : await streamToBuffer(incoming);
            const ext = (req.data.imageType || 'image/png').split('/')[1] || 'png';
            const path = await uploadImage(ID, buf, ext);

            req.data.fileName = path;
            req.data.imageType = req.data.imageType || 'image/png';
            req.data.image = null;
        });

         this.before('NEW', Inventories.drafts, async (req) => {
            const [persisted, drafts] = await Promise.all([
                SELECT.one.from(Inventories)
                    .columns({ func: 'max', args: [{ ref: ['stockNumber'] }], as: 'maxStock' }),
                SELECT.one.from(Inventories.drafts)
                    .columns({ func: 'max', args: [{ ref: ['stockNumber'] }], as: 'maxStock' }),
            ]);

            const toNum = (v) => {
                const n = parseInt(v, 10);
                return Number.isFinite(n) ? n : 0;
            };

            const next = Math.max(toNum(persisted?.maxStock), toNum(drafts?.maxStock)) + 1;

            // Pad a 4 dígitos: '0001', '0002', ... ajusta según tu String(N)
            req.data.stockNumber = String(next).padStart(4, '0');
        });


        // ──────────────────────────────────────────────────────────────
        // 3) READ del stream (GET .../Products(...)/image)
        //    - Activo: bajar de Dropbox
        //    - Draft : default (LargeBinary local del draft)
        // ──────────────────────────────────────────────────────────────
        this.on('READ', Products, async (req, next) => {
            // ¿Es petición de stream del campo image?  → la URL termina en /image
            const url = req._?.req?.path || req._?.req?.url || '';
            const isStreamReq = /\/image(\?|$)/.test(url);
            if (!isStreamReq) return next();

            // Solo interceptamos el activo. En draft, dejamos el comportamiento default
            // (el binary vive en la tabla _drafts).
            const key = req.params?.[0] || {};
            const isActive = key.IsActiveEntity === true || key.IsActiveEntity === 'true';
            if (!isActive) return next();

            const meta = await SELECT.one.from(Products)
                .columns('fileName', 'imageType')
                .where({ ID: key.ID });

            if (!meta?.fileName) return null;          // sin imagen → 204

            const buf = await downloadImage(meta.fileName);
            return Readable.from(buf);                  // ← Readable directo, NO array
        });

           // ──────────────────────────────────────────────────────────────
        // 4) DELETE producto activo → borrar archivo en Dropbox
        // ──────────────────────────────────────────────────────────────
        this.before('DELETE', Products, async (req) => {
            const ID = req.params?.[0]?.ID;
            if (!ID) return;
            const prev = await SELECT.one.from(Products).columns('fileName').where({ ID });
            if (prev?.fileName) await deleteImage(prev.fileName);
        });

        //Action
        this.on('setStock', async (req) => {
            // Products.satatu_code -> InStock, OutOfStock o LowAvailability
            //quantity >= 300 -> InStock
            //quantity = 0 --> OutOfStock
            //quantity >=0 and <300 -> LowAvailability




            const sProductId = req.params[0].ID;
            const sInventoryId = req.params[1].ID;
            const result = await SELECT.one.from(Inventories).columns('quantity').where({ ID: sInventoryId });
            let newQuantity = 0;
            if(req.data.option === 'A'){
                newQuantity = result.quantity + req.data.amount;
                await UPDATE(Inventories).set({quantity : newQuantity}).where({ID: sInventoryId});
                if(newQuantity >= 300){
                    await UPDATE(Products).set({statu_code : 'InStock'}).where({ID: sProductId});
                } 
                return req.info(200, `The amount ${req.data.amount} has been added to inventory ${sInventoryId}`);
            } else if((result.quantity - req.data.amount) < 0){
                return req.error(400, `There is no avaiability for the requested quantity`);
            } else{
                newQuantity = result.quantity - req.data.amount;
                if(newQuantity === 0){
                    await UPDATE(Products).set({statu_code : 'OutOfStock'}).where({ID: sProductId});
                } else if(newQuantity < 300){
                    await UPDATE(Products).set({statu_code : 'LowAvailability'}).where({ID: sProductId});
                }
                await UPDATE(Inventories).set({quantity : newQuantity}).where({ID: sInventoryId});
                return req.info(200, `The amount ${req.data.amount} has been substracted from inventory ${sInventoryId}`);
            }

        });

        //registerImageHandlers(this);

        return super.init();
    }
};