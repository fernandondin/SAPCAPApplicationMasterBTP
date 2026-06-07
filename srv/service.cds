using {com.logaligroup as entities} from '../db/schema';

service ProductsService {
    type dialog{
        myOption : String(10);
        myAmount: Integer
    };
    entity Products         as projection on entities.Products;
    entity ProductDetails   as projection on entities.ProductDetails;
    entity Suppliers        as projection on entities.Suppliers;
    entity Contacts         as projection on entities.Contacts;
    entity Reviews          as projection on entities.Reviews;
    entity Inventories      as projection on entities.Inventories actions{
        @Common:{
            SideEffects:{
                $Type: 'Common.SideEffectsType',
                TargetProperties:[
                    'in/quantity'
                ],
                TargetEntities:[
                    in.product
                ]
            }
        }
        action setStock (
            in: $self,
            option: dialog:myOption,
            amount: dialog:myAmount,
        )
    };
    entity Sales            as projection on entities.Sales;

    /** Entities - Value Help */
    entity Status           as projection on entities.Status;

    @readonly
    entity VH_Categories    as projection on entities.Categories;

    @readonly
    entity VH_SubCategories as projection on entities.SubCategories;

    @readonly
    entity VH_Departments as projection on entities.Departments;

    @readonly
    entity VH_Options as projection on entities.Options;
};