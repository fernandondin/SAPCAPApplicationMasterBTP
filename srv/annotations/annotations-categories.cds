using {Products as myservice} from '../service';

annotate myservice.VH_Categories with {
    ID           @title: 'Categories';
    category     @title: 'Category';
    description  @title: 'Description';
};

annotate myservice.VH_Categories with{
    ID @Common :{
        Text: category,
        TextArrangement : #TextOnly,
    };
};