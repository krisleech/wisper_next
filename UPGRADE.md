Changes from Wisper 2.x

`#broadcast` only takes two arguments, the event name and a payload.

If you have listeners which receive events which they can not handle, i.e. do
not have a matching method, you will now get an exception raised. You can
disable this behaviour and silently ignore events which can not be handled with
`include Wisper.subscriber(strict: false)`.
