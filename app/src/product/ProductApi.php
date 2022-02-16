<?php

use SilverStripe\CMS\Controllers\ContentController;
use SilverStripe\CMS\Model\SiteTree;
use SilverStripe\Assets\Upload;
use SilverStripe\Control\HTTPResponse;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class ProductApiPage extends Page
{
  
}

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class ProductApiPageController extends ApiPageController
{
  public $merchant, $customer , $checkToken, $id, $otherID;

  private static $allowed_actions = [
    'store',
    'show',
    'update',
    'destroy',
    'merchant',
    'addImage',
    'destroyImage',
    'isAvail'
  ];

  public function doInit()
  {
    parent::doInit();
    $this->checkToken = $this->checkAccessToken('Merchant');
    if($this->checkToken['status'] == 'ok'){
      $this->merchant = $this->checkToken['data'];
    }

    $this->checkTokenCustomer = $this->checkAccessToken('Customer');
    if($this->checkTokenCustomer['status'] == 'ok'){
      $this->customer = $this->checkTokenCustomer['data'];
    }

    $this->id = $this->request->param('ID');
    $this->otherID = $this->request->param('OtherID');
  }

  public function index()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }
    // if($this->checkTokenCustomer['status'] == 'no'){
    //   return new HTTPResponse(json_encode($this->checkTokenCustomer), 403);
    // }

    $products = Product::get();
    $arrProduct = [];
    foreach($products as $product){
      $arrProduct[] = $product->toArray();
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully get all product',
      'data' => $arrProduct
    ]);
  }

  public function merchant()
  {
    if($this->checkToken['status'] == 'no'){
      return new HTTPResponse(json_encode($this->checkToken), 403);
    }
    $id = $this->merchant->ID;
    $products = Product::get()->filter([
      'MerchantID' => $id,
      'IsDelete' => false
    ])->sort('Created', 'DESC');
    $arrProduct = [];
    foreach($products as $product){
      $arrProduct[] = $product->toArray();
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully get all product merchant',
      'data' => $arrProduct
    ]);
  }

  public function store()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }
    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }
    
    $product = Product::create();
    $product->Title = $_REQUEST['title'];
    $product->Price = $_REQUEST['price'];
    $product->MerchantID = $this->merchant->ID;
    $product->write();

    return new HTTPResponse(json_encode([
      'status' => 'ok',
      'message' => 'Successfully store new product',
      'data' => $product->toArray()
    ]), 201);
    
    // if($product->ID){
    //   $upload = new Upload();
    //   foreach($_FILES['images']['name'] as $key => $name){
    //     $photo = CustomImage::create();
    //     $temp = [];
    //     $temp['name'] = $name;
    //     $temp['type'] = $_FILES['images']['type'][$key];
    //     $temp['tmp_name'] = $_FILES['images']['tmp_name'][$key];
    //     $temp['error'] = $_FILES['images']['error'][$key];
    //     $temp['size'] = $_FILES['images']['size'][$key];

    //     $upload->loadIntoFile($temp, $photo, 'product-images');
    //     $photo->ProductID = $product->ID;
    //     $photo->write();
    //   }

    //   return json_encode([
    //     'status' => 'ok',
    //     'message' => 'Successfully store new product',
    //     'data' => $product->toArray()
    //   ]);
    // }
    
  }

  public function show()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    $product = Product::get()->byID($this->id);

    if(!$product){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Product not found'
      ]), 404);
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully get one product',
      'data' => $product->toArray()
    ]);
  }

  public function update()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }
    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }
    
    // $id = $this->request->param('ID');
    $product = Product::get()->byID($this->id);

    if(!$product){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Product not found'
      ]), 404);
    }

    $product->Title = $_REQUEST['title'];
    $product->Price = $_REQUEST['price'];
    $product->write();

    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully update product',
      'data' => $product->toArray()
    ]);
  }

  public function destroy()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }
    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    $product = Product::get()->byID($this->id);
    if(!$product){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Product not found'
      ]), 404);
    }

    $product->IsDelete = True;
    $product->write();
    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully delete product',
      'data' => $product->toArray()
    ]);
  }

  public function addImage()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }
    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }
    
    $product = Product::get()->byID($this->id);

    if(!$product){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Product not found'
      ]), 404);
    }

    $file = $_FILES['images'];

    $Image = CustomImage::create();
    $upload = new Upload();
    $photo = CustomImage::create();
    $upload->loadIntoFile($file, $photo, 'product-images');
    $photo->ProductID = $product->ID;
    $photo->write();

    $product = Product::get()->byID($this->id);

    return new HTTPResponse(json_encode([
      'status' => 'ok',
      'message' => 'Successfully add image',
      'data' => $product->toArray()
    ]), 201);
  }

  public function destroyImage()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }
    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    // $product = Product::get()->byID($this->id);
    $image = CustomImage::get()->filter([
      'Product.ID' => $this->id,
      'ID' => $this->otherID
    ])->first();

    if(!$image){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Image not found'
      ]), 404);
    }

    $image->delete();

    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully delete image product',
      'data' => $image->toArray()
    ]);
  }

  public function isAvail()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }
    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    $isAvailable = $this->otherID == 'true' ? true : false;

    $product = Product::get()->filter([
      'ID' => $this->id,
      'MerchantID' => $this->merchant->ID
    ])->first();

    if(!$product){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Product not found'
      ]), 404);
    }

    $product->IsAvailable = $isAvailable;
    $product->write();

    $status = $isAvailable ? 'available' : 'not available';
    return json_encode([
      'status' => 'ok',
      'message' => "Now Product is $status",
      'data' => $product->toArray()
    ]);
  }
}
?>