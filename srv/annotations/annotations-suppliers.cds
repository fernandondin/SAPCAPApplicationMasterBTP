using {ProductsService as myservice} from '../service';
using from './annotations-contacts';

annotate myservice.Suppliers with {
    ID           @title: 'Supplier' @Common.FieldControl : #ReadOnly;
    supplier     @title: 'Supplier'@Common.FieldControl : #ReadOnly;
    supplierName @title: 'Supplier Name'@Common.FieldControl : #ReadOnly;
    webAddress   @title: 'Web Address'@Common.FieldControl : #ReadOnly;
};

annotate myservice.Suppliers with{
    ID @Common :{
        Text: supplierName,
        TextArrangement : #TextOnly,
    };
};

annotate myservice.Suppliers with @(
    UI.FieldGroup #SupplierInformation : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
               $Type : 'UI.DataField',
               Value : supplier 
            },
            {
                $Type : 'UI.DataField',
                Value : supplierName,
            },
            {
                $Type : 'UI.DataField',
                Value : webAddress,
            },
        ],
    },
    Communication.Contact : {
        $Type : 'Communication.ContactType',
        fn    : supplierName,
        tel   : [
            {
                $Type : 'Communication.PhoneNumberType',
                type  : #work,
                uri   : contact.phoneNumber
            }
        ],
        email : [
            {
                $Type : 'Communication.EmailAddressType',
                type  : #work,
                address : contact.email
            }
        ],
        url   : [
            {
                $Type : 'Communication.UrlType',
                type  : #work,
                uri   : webAddress
            }
        ],
        adr : [
            {
                $Type : 'Communication.AddressType',
                type     : #work,
                street   : 'USA 246-12',
                locality : 'Doral Center',
                region   : 'FL',
                code     : '33122',
                country  : 'US'
            }
        ]
    }
);