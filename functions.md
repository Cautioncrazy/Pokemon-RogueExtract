### pbInflictStatus
The base engine's `pbInflictStatus` function is used for all custom statuses. It takes the same parameters.

**Signature:** `battler.pbInflictStatus(status_id, status_count = 0, msg = nil, user = nil)`
**Parameters:**
- `status_id` (Symbol): The `:id` of the status to inflict (e.g., `:BLEEDING`, `:BLINDNESS`, `:SHAKEN`).
- `status_count` (Integer): Optional. Number of turns the status should last. Default is 0.
- `msg` (String): Optional. Message to display when inflicted.
- `user` (Battler): Optional. The battler inflicting the status.

**Example usage in a move effect:**
```ruby
if target.pbCanInflictStatus?(:BLEEDING, user, false, self)
  target.pbInflictStatus(:BLEEDING, 0, _INTL("{1} began to bleed!", target.pbThis), user)
end
```
