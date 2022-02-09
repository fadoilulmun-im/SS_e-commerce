<?php

use SilverStripe\CMS\Controllers\ContentController;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class ShopPageController extends PageController
{
  public function doInit()
  {
    parent::doInit();
  }

  private static $allowed_actions = [
    'show',
    'search'
  ];

  public function show()
  {
    return [];
  }

  public function search()
  {
    $id = $this->request->param('ID');
    return ['id' => $id];
  }
}
?>