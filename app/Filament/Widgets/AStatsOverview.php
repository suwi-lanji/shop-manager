<?php

namespace App\Filament\Widgets;

use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use App\Models\Order;
use App\Models\Product;
use App\Models\Expense;
use App\Models\Credit;
use App\Models\OrderProduct;

class AStatsOverview extends BaseWidget
{
    protected function getHeading(): ?string
    {
        return 'Reports';
    }

    protected function getDescription(): ?string
    {
        return 'Business performance reports.';
    }
    protected function getStats(): array
    {
        $total_revenue = Order::all()->sum('amount') - Expense::all()->sum('amount');
        $products_sold = OrderProduct::all()->sum('quantity');
        $total_expenses = Expense::all()->sum('amount');
        return [
            Stat::make('Total Revenue', 'K'.$total_revenue)
            ->description('Sales Earning - Expenses'),
            Stat::make('Products Sold', '+'.$products_sold)
            ->description('Number of products sold accross all items'),
            Stat::make('Total Expenses', 'K'.$total_expenses)
            ->description('Sum of all expenses'),
            Stat::make('Total Credits', 'K'.Credit::all()->sum('amount'))
            ->description('Total amount owed to business by debtors')
        ];
    }
}
