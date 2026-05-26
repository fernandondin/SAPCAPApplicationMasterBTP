namespace com.logaligroup;

using {
    cuid,
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

entity Products : cuid, managed {
    product       : String(10);
    productName   : String(40);
    description   : LargeString;
    category      : Association to Categories;
    subCategory   : Association to SubCategories;
    statu         : Association to Status;
    price         : Decimal(6, 2);
    rating        : Decimal(3, 2);
    currency      : String;
    detail        : Association to ProductDetails; //detail_ID
    supplier      : Association to Suppliers;
    toReviews     : Association to many Reviews
                        on toReviews.product = $self;
    toInventories : Association to many Inventories
                        on toInventories.product = $self;
    toSales: Association to many  Sales on toSales.product = $self;
}

type myDecimal : Decimal(8, 3);


entity ProductDetails : cuid {
    baseUnit   : String default 'EA';
    height     : myDecimal;
    depth      : myDecimal;
    weight     : myDecimal;
    unitVolume : String default 'CM';
    unitWeight : String default 'KG';
}

entity Categories : cuid {
    category        : String(40);
    description     : LargeString;
    toSubcategories : Association to many SubCategories
                          on toSubcategories.cartegory = $self;
}

entity SubCategories : cuid {
    subCategorie : String(40);
    description  : LargeString;
    cartegory    : Association to Categories; //(category_ID)
}

entity Suppliers : cuid {
    supplier     : String(10);
    supplierName : String(40);
    webAddress   : String(250);
    contact      : Association to Contacts;
}

entity Contacts : cuid {
    fullName    : String(40);
    email       : String(80);
    phoneNumber : String(14);
}

entity Reviews : cuid {
    rating     : Decimal(3, 2);
    date       : Date;
    user: String(20);
    reviewText : LargeString;
    product    : Association to Products;
}

entity Inventories : cuid {
    stockNumber : String(10);
    department  : Association to Departments;
    min         : Integer;
    max         : Integer;
    target      : Integer;
    quantity    : Decimal(6, 3);
    baseUnit    : String default 'EA';
    product     : Association to Products;
}

entity Sales : cuid {
    month         : String(20);
    monthCode: String(2);
    year          : String(4);
    quantitySales : Integer;
    product       : Association to Products;
}

entity Departments : cuid {
    department  : String(40);
    description : String;
}

entity Status : CodeList {
    key code : String(20) enum {
            InStock = 'In Stock';
            OutStock = 'Out of Stock';
            LowAvailability = 'Low Availability';
        }
}
