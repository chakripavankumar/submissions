from pricing import (
    member_price,
    delivery_fee,
    loyalty_points,
)


def test_member_price():
    assert member_price(1000, 10) == 900


def test_member_price_zero_discount():
    assert member_price(1000, 0) == 1000


def test_member_price_full_discount():
    assert member_price(250, 100) == 0


def test_delivery_fee_below_threshold():
    assert delivery_fee(499) == 50


def test_delivery_fee_at_threshold():
    assert delivery_fee(500) == 0


def test_loyalty_points():
    assert loyalty_points(100) == 1


def test_loyalty_points_below_threshold():
    assert loyalty_points(99) == 0