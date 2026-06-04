using { ProductsService as myservice } from '../service';

annotate myservice.Sales with {
    month @title : 'Month';
    monthCode @title : 'Month Code';
    year @title : 'Year';
    quantitySales @title : 'Quantity Sales';
};

annotate myservice.Sales @(
    Analytics.AggregatedProperty #sum :{
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'Sales',
        AggregationMethod : 'sum',
        AggregatableProperty : quantitySales,
        @Common.Label: 'Sales'
    },
    Aggregation.ApplySupported :{
        GroupableProperties : [
            month,
            year
        ],
        AggregatableProperties : [
            {
                $Type : 'Aggregation.AggregatablePropertyType',
                Property : quantitySales
            }
        ]
    },
    UI.Chart :{
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Line,
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#sum'
        ],
        Dimensions : [
            year,
            month
        ]
    }
 )

