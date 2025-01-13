<?php

namespace App\Models;

use Filament\Models\Contracts\HasAvatar;
use Illuminate\Database\Eloquent\Model;

class Store extends Model implements HasAvatar
{
    protected $guarded = [];
    public function getFilamentAvatarUrl(): ?string
    {
        return env('APP_URL') . '/storage/' . $this->img_url;
    }
    public function users()
    {
        return $this->belongsToMany(User::class, 'store_user');
    }

    public function members()
    {
        return $this->belongsToMany(User::class, 'store_user');
    }

    public function products()
    {
        return $this->hasMany(Product::class);
    }

    public function expenses()
    {
        return $this->hasMany(Expense::class);
    }
}
