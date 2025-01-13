<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Store extends Model
{
    protected $guarded = [];

    public function users()
    {
        return $this->belongsToMany(User::class, 'store_user');
    }

    public function members()
    {
        return $this->belongsToMany(User::class, 'store_user');
    }
}
