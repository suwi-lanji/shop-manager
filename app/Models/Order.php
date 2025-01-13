<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    public function products()
    {
        return $this->belongsToMany(Product::class, 'order_product');
    }

    public function store()
    {
        return $this->belongsTo(Store::class);
    }
}
