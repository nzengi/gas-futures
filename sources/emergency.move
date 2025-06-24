module gas_futures::emergency {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::event;

    public struct EmergencySwitch has key { 
        id: UID,
        is_paused: bool
    }

    public struct PausedEvent has copy, drop, store {
        timestamp: u64
    }

    // Emergency switch creation (entry function)
    public entry fun create_emergency_switch(ctx: &mut TxContext) {
        let switch = EmergencySwitch {
            id: object::new(ctx),
            is_paused: false
        };
        sui::transfer::transfer(switch, tx_context::sender(ctx));
    }

    // Pause the contract
    public entry fun pause_contract(
        switch: &mut EmergencySwitch,
        ctx: &mut TxContext
    ) {
        switch.is_paused = true;
        event::emit(PausedEvent { timestamp: tx_context::epoch_timestamp_ms(ctx) });
    }

    // Unpause the contract
    public entry fun unpause_contract(
        switch: &mut EmergencySwitch,
        ctx: &mut TxContext
    ) {
        switch.is_paused = false;
        event::emit(PausedEvent { timestamp: tx_context::epoch_timestamp_ms(ctx) });
    }

    // Check emergency status (for other modules)
    public fun is_paused(switch: &EmergencySwitch): bool {
        switch.is_paused
    }

    // Emergency switch creation
    public fun new(ctx: &mut TxContext): EmergencySwitch {
        EmergencySwitch {
            id: object::new(ctx),
            is_paused: false
        }
    }

    // Make EmergencySwitch shared
    public entry fun share(switch: EmergencySwitch) {
        sui::transfer::share_object(switch);
    }

    // Return EmergencySwitch (for other modules)
    public entry fun return_switch(switch: EmergencySwitch, ctx: &mut TxContext) {
        sui::transfer::transfer(switch, tx_context::sender(ctx));
    }
}