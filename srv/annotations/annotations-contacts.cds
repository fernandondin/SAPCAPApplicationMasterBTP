using {ProductsService as myservice} from '../service';

annotate myservice.Contacts with{
    fullName @title : 'Full Name'@Common.FieldControl : #ReadOnly;
    email @title : 'Email'@Common.FieldControl : #ReadOnly;
    phoneNumber @title : 'Phone Number'@Common.FieldControl : #ReadOnly;

} ;

annotate myservice.Contacts with @(
    UI.FieldGroup #Contacts : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : fullName,
            },
            {
                $Type : 'UI.DataField',
                Value : email,
            },
            {
                $Type : 'UI.DataField',
                Value : phoneNumber,
            },
        ]
    }
)