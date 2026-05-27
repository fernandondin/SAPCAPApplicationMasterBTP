using {Products as myservice} from '../service';

annotate myservice.VH_SubCategories with {
    ID           @title: 'Categories';
    subCategory   @title: 'Category';
    description  @title: 'Description';
};

annotate myservice.VH_SubCategories with{
    ID @Common :{
        Text: subCategory,
        TextArrangement : #TextOnly,
    };
};