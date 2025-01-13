<?php

namespace App\Filament\Pages\Tenancy;

use App\Models\Store;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Form;
use Filament\Pages\Tenancy\RegisterTenant;
use Illuminate\Support\Facades\Auth;

class RegisterStore extends RegisterTenant
{
    public static function getLabel(): string
    {
        return 'Register store';
    }

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('name')->required(),
                FileUpload::make('img_url')->image()->label('Store logo')->required(),
                Textarea::make('description')->required(),
                TextInput::make('location')->required(),
            ]);
    }

    protected function handleRegistration(array $data): Store
    {
        $store = Store::create($data);
        dd(Auth::id());
        $store->members()->attach(Auth::id());

        return $store;
    }
}
