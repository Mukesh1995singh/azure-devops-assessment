INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),
    (
        ARRAY[
            '11111111-1111-1111-1111-111111111111'::uuid,
            '22222222-2222-2222-2222-222222222222'::uuid,
            '33333333-3333-3333-3333-333333333333'::uuid,
            '44444444-4444-4444-4444-444444444444'::uuid
        ]
    )[1 + floor(random() * 4)::int],

    'HOTEL-' || LPAD((1 + floor(random() * 20))::int::text, 3, '0'),

    (
        ARRAY[
            'delhi',
            'mumbai',
            'bangalore',
            'hyderabad',
            'pune',
            'chennai',
            'kolkata',
            'noida'
        ]
    )[1 + floor(random() * 8)::int],

    CURRENT_DATE + floor(random() * 30)::int,

    CURRENT_DATE + 2 + floor(random() * 30)::int,

    ROUND((1500 + random() * 18500)::numeric, 2),

    (
        ARRAY[
            'confirmed',
            'cancelled',
            'pending',
            'completed'
        ]
    )[1 + floor(random() * 4)::int],

    NOW() - (floor(random() * 60)::int || ' days')::interval

FROM generate_series(1, 120);


INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    b.id,
    event.event_type,
    jsonb_build_object(
        'booking_id', b.id,
        'hotel_id', b.hotel_id,
        'city', b.city,
        'status', b.status
    ),
    b.created_at + (floor(random() * 5)::int || ' hours')::interval
FROM (
    SELECT
        id,
        hotel_id,
        city,
        status,
        created_at
    FROM hotel_bookings
    ORDER BY random()
    LIMIT 60
) b
CROSS JOIN LATERAL (
    SELECT unnest(
        ARRAY[
            'booking_created',
            'booking_updated'
        ]
    ) AS event_type
) event;