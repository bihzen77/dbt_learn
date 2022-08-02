select 
id,
orderid as order_id,
paymentmethod as payment_method,
status,
amount,
created, 
_batched_at
from  `shaped-gravity-358002.stripe.payment` 