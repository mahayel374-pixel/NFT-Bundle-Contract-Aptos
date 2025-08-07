module maha_addr::NFTBundle {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;
    struct Bundle has store, key {
        nft_ids: vector<u64>,    
        price: u64,              
        is_for_sale: bool,       
        owner: address,          
    }
    public fun create_bundle(
        creator: &signer, 
        nft_ids: vector<u64>, 
        price: u64
    ) {
        let creator_address = signer::address_of(creator);
        let bundle = Bundle {
            nft_ids,
            price,
            is_for_sale: true,
            owner: creator_address,
        };
        move_to(creator, bundle);
    }
    public fun purchase_bundle(
        buyer: &signer, 
        bundle_owner: address, 
        payment_amount: u64
    ) acquires Bundle {
        let bundle = borrow_global_mut<Bundle>(bundle_owner);
        assert!(bundle.is_for_sale, 1);
        assert!(payment_amount == bundle.price, 2);
        let payment = coin::withdraw<AptosCoin>(buyer, payment_amount);
        coin::deposit<AptosCoin>(bundle.owner, payment);
        bundle.owner = signer::address_of(buyer);
        bundle.is_for_sale = false;
    }
}
