using { Products as myservice } from '../service';

annotate myservice.Reviews with{
    date @title : 'Date';
    user @title : 'User';
    rating @title : 'Rating';
    reviewText @title : 'Review Text';
} ;

annotate myservice.Reviews with @(
    UI.HeaderInfo : {
        TypeName : 'Review',
        TypeNamePlural : 'Reviews',
        Title : {
            $Type : 'UI.DataField',
            Value : product.productName
        },
        Description :{
            $Type : 'UI.DataField',
            Value : product.product
        }
    },
    UI.LineItem #Reviews : [
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint#RatingReview',
            @HTML5.CssDefaults :{
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            $Type : 'UI.DataField',
            Value : date,
        },
        {
            $Type : 'UI.DataField',
            Value : reviewText,
        },
    ],
    UI.FieldGroup #ReviewInformation :{
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.DataPoint#RatingReview',
                @HTML5.CssDefaults :{
                    $Type : 'HTML5.CssDefaultsType',
                    width : '10rem',
                }
            },
            {
                $Type : 'UI.DataField',
                Value : date,
            },
            {
                $Type : 'UI.DataField',
                Value : user,
            },
            {
                $Type : 'UI.DataField',
                Value : reviewText,
            },
        ]
    },
    UI.Facets  : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#ReviewInformation',
            Label : 'Information'
        },
    ],
    UI.DataPoint #RatingReview :{
        $Type : 'UI.DataPointType',
        Value : rating,
        Visualization : #Rating,
    }
);


