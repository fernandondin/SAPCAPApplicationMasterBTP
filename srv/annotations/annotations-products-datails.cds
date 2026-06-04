using {ProductsService as myservice} from '../service';


annotate myservice.ProductDetails with {
    width      @title: 'Width'   @Measures.Unit: unitVolume;
    height     @title: 'Height'  @Measures.Unit: unitVolume;
    depth      @title: 'Depth'   @Measures.Unit: unitVolume;
    weight     @title: 'Weight'  @Measures.Unit: unitWeight;
    unitVolume @Common.IsUnit @Common.FieldControl : #ReadOnly;
    unitWeight @Common.IsUnit @Common.FieldControl : #ReadOnly;
};