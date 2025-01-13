<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Expense extends Model
{
    protected $guarded = [];
    public function store()
    {
        return $this->belongsTo(Store::class);
    }
}
