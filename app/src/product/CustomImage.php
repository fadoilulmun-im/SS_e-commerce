<?php
use SilverStripe\Assets\Image;

class CustomImage extends Image
  {
    private static $has_one = [
      'Product' => Product::class,
    ];

    public function toArray()
    {
      $arr = [
        'ID' => $this->ID,
        'Title' => $this->Title,
        'Link' => $this->Link()
      ];

      return $arr;
    }
  }
?>