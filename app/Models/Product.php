<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $guarded = [];
    protected function casts(): array
    {
        return [
            'images' => 'array',
        ];
    }
    public function store()
    {
        return $this->belongsTo(Store::class);
    }

    public function orders()
    {
        return $this->belongsToMany(Order::class, 'order_product');
    }
}
