use alexandria_storage::proof::{
    ContractStateProof, ContractData, TrieNode, BinaryNode, EdgeNode, verify
};

// https://starknet-mainnet.infura.io/v3/56387818e18e404a9a6d2391af0e9085/pathfinder_getProof?block_id=250892&contract_address=0x00da114221cb83fa859dbdb4c44beeaa0bb37c7537ad5ae66fe5e0efd20e6eb3&keys=2117247447557615580232880247660287673016585442967031609456891751455210391278
// from starkware.starknet.public.abi import get_selector_from_name, get_storage_var_address, starknet_keccak
// func _total_supply() -> (res : Uint256):
// >>> get_storage_var_address('_total_supply')
// 1573539189056010122409627604753564340634217657387620680833138697715618498052
// func _balances(user : felt) -> (res : Uint256):
// >>> get_storage_var_address('_balances', 0x063c94d6B73eA2284338f464f86F33E12642149F763Cd8E76E035E8E6A5Bb0e6)
// 2117247447557615580232880247660287673016585442967031609456891751455210391278

#[test]
#[available_gas(20000000)]
fn proof1_test() {
    let state_commitment = 0x62d46304c0c4e8d63719b59e103240668471d8b14560a25d202684e976dffad;
    let contract_address = 0x7412b9155cdb517c5d24e1c80f4af96f31f221151aab9a9a1b67f380a349ea3;
    let storage_address = 0x4b14f70a10d78816915e32a2bffa292270624cf4868f40cd489f78e2edc5bb4;
    let expected_value =
        3297450976341993905338014621774626109218148093827950687289193790013996697606;
    let proof = ContractStateProof {
        class_commitment: 0x6908bc7170558a6151a74fab7869c0c96adf5f0cc51f0129fe3ce61a57d3351,
        contract_proof: array![
            TrieNode::Binary(
                BinaryNode {
                    left: 0x60a055bdf5ade8f092082d82475090b69aebd1e2bc7c2039e910cba982198d,
                    right: 0x6c41436549957052799bf45751fc55f8c457a59ea682a327b4c5818538ddd7f
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x22c4e50203b9f288b96b7710f780e43092a8c054cbc213939364614de0901eb,
                    right: 0x6bcd6399bcc3efedcc799892453da3f62557adff734cecccd161a303fba7256
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x34f1bba366ee0c5631c03a09e1ae82bdb0cd8b89df54b9bd18fdab6a7e4ef5b,
                    right: 0x2c9884db284898cdcaa2eb23480b0ba61790570ce9af77880927e1b9995e8da
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x4290e513e49c20fef2adffc677638dbe302c2f48e98bb20ed378ba943c7a5f1,
                    right: 0x5c37af53a243777c2439d23b92a4d2600d3b666d4e48ff57bc637975840f34e
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x706f9302581de511e933d767575372aa8535da97a75797e56d98ad261a8b188,
                    right: 0x49fda932d16510c508293c90e1a01e00514954fb294120c8432ff426e982cbc
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x519fa0a8c305155d1a12b08bd950d0087804f504cc7c51933fd1c352a816740,
                    right: 0x44d6a28b0ae6c2170b8ead6ceb60996f2d9043e3390c28b97bdaeaec1b76335
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x3b2b1bc60eb7cb8908d76da55a80dff9d462f572ddc02bdc94e03ddee26f692,
                    right: 0x37dde7edf8e04bbee23f4c6a4297ba9c7e6444e7d3cda5d68ad5b0dc8b2afc4
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x1272231983089a032d0142e9b57ac3161fb2e4639592c7fb63ab7d7c2673341,
                    right: 0xb8df9e82851360df2f8f4afa3c7ab763e96a243b1274bceb99d4f40c2565fc
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0xbe6f8d0802a40beb80ebacaabb1ad92d98402c628904d45c622a2145a9b249,
                    right: 0x5fce707021e9a9015f0c0c4be3c4d5cfdf4c58cdf55608da02313437b12bdba
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x7eba4600a87aed03af0e3f0c75a06b3b22c0e6dbf819edaa3b922469928b762,
                    right: 0x599648104befa3ef01477ad408e321f31f2413e7c78a562781568a9b41e0a89
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x2568f00437b09ec74fdc06e0e41e27f6e9f5b5bbcc3d3ef85c01fa67cfc4035,
                    right: 0x5be50e398528134fc8640ca00d844228702d1fbc1753cb34b98bf9cddf6a8c5
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x79a5e5f1ad78bfbd7a110432db2fd49072d4883965cb2ac55198a94c5c7ba12,
                    right: 0xf19f1cd20223e955054fbc9e47bca6f2b25cc909b5a03efc990fe0fb377518
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x4139fc2eaacf9b03460e911959f0fda6b8af185a1ddbc9a101ed0ab077244bd,
                    right: 0x13063f8612e2d89235aa16db7e05f0297a98e2b275f21882986e00eed7a8dbf
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x20a1c381b4619b2a94969d7be7f5e097f7f2f339124ca329be256fc6662fb90,
                    right: 0x5bc6fffeecdaaf22b5f4dce15fb2560fd11c9c2ee11ba29d39a0669bb3c8af5
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x424e8243c1548b86c06d6cffb4e6bf363b980944ba22e171487fea191cb3ef2,
                    right: 0x1695fd8218b0175e88693412b471c20046acf1dfb5720ed53a989e7f948fa08
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x534a3a0cff8c6858bdbe8e48108091d5db22c18b2120afbd737871672ceb37b,
                    right: 0x761879d87c862b444546343d24e2cefae5d43e0c783aeae242705eaab528f85
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x2da96c5eb5cc446c18f113d751d4716ede23f22c9746f19a82d5b555c22aea7,
                    right: 0x2be5c87cb84afbde29866039ae6db1d6c7b309c76107d7bb74e9d9fad26db40
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x6eacd249a53e818477f9040b40da39502b5f3ef05293363e8057f6dc47a32af,
                    right: 0x205cb25ee1c47bef4521392d2697ce5364269b0f90b3bacfbe25c33ee0cc1a1
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x4f56abda2448a83a60826ed5c6afbbbf6c5f462591308c4ad8225aa317e7ec,
                    right: 0x198aaa190abfa9a7649f92e7d72ca7b8bd277afa123c48c014113c44c8c985f
                }
            ),
            TrieNode::Edge(
                EdgeNode {
                    path: 0x4,
                    length: 3,
                    child: 0x721435066110f1257c2f6b2573d561429a6a6f2552975bf839a8565143a4c58
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x83ba67cb3d3b8a79eb9b8d080b9d8bb491f413ed9ef2fc9bf95a625bbb3aac,
                    right: 0x616976ddd5588fa313b9aa6e22efef0ff65c9ddaa17746c7f3386b2fd8f3659
                }
            ),
            TrieNode::Edge(
                EdgeNode {
                    path: 0x155cdb517c5d24e1c80f4af96f31f221151aab9a9a1b67f380a349ea3,
                    length: 228,
                    child: 0x8952b874f58dc21884ee7b5002e007800ca872a000d4e7eaa9f52171282ef0
                }
            )
        ],
        contract_data: ContractData {
            class_hash: 0xeafb0413e759430def79539db681f8a4eb98cf4196fe457077d694c6aeeb82,
            nonce: 0,
            contract_state_hash_version: 0,
            storage_proof: array![
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x2ca1cd14bb9b1fb5104f29404f157c6b0614708da53b2d6374b4a1e5e3f0c1b,
                        right: 0x20e0e97a718b6801c9c83b64c4033ed99a446ee4ad47da6bd1216f4c0774
                    }
                ),
                TrieNode::Edge(
                    EdgeNode {
                        path: 0x0,
                        length: 1,
                        child: 0x3392cfc52ca139634f457d7f0f83bc2d89baae2c8146f7527de07cdfb6e309
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x68b12e9e81c02739cc4cc3c3836089f7c5572d10fcbe677a8cdba984b0a6ee1,
                        right: 0x3a93f9856b6edb281dcfa2817cd45c39a0616bce5b67db50bd64d0d50a4821c
                    }
                ),
                TrieNode::Edge(
                    EdgeNode {
                        path: 0xb14f70a10d78816915e32a2bffa292270624cf4868f40cd489f78e2edc5bb4,
                        length: 248,
                        child: 0x74a4a866e2d5c9f0a91ef0ef2ec92c4268ad170da78d79badbd7064468e8806
                    }
                )
            ]
        }
    };
    let value = verify(state_commitment, contract_address, storage_address, proof);
    assert(expected_value == value, 'wrong value');
}

#[test]
#[available_gas(50000000)]
fn proof2_test() {
    let state_commitment = 0x5de4713d440dcc861552edc8a86cee0c4a0014d8fb0138b27b16cddec6535e5;
    let contract_address = 0x00da114221cb83fa859dbdb4c44beeaa0bb37c7537ad5ae66fe5e0efd20e6eb3;
    // get_storage_var_address('_balances', 0x063c94d6B73eA2284338f464f86F33E12642149F763Cd8E76E035E8E6A5Bb0e6)
    let storage_address = 0x4ae51d08cd202d1472587dfe63dbf2d5ec767cbf4218b59b7ab71956780c6ee;
    let expected_value = 8700000000000000005;
    let proof = ContractStateProof {
        class_commitment: 0x6e0cc249cf3a3540fef5d0849d2555a08f712ab3ef823317ae2b8b34e4e394f,
        contract_proof: array![
            TrieNode::Binary(
                BinaryNode {
                    left: 0x53d4cddb6f594066362a612114dc18d8fc52ecefeadcc48d801f2c2fb8c7c6d,
                    right: 0x2e0ddde5c2ab0edfa8a559f9df1b41d38d327d59a9c6aff938f3cd636030749
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x66141bc9464615b1c0d600712433644e3464facd9bb77d4a507dd813b56c9,
                    right: 0x218f53d6cd1aee55be9192c808affa8cb9f8b86c89da1bea755d19a90dd92b4
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x6d4c17d8ad48f3df4517626e2a5da3101325d391c3024683b3838b67f947faa,
                    right: 0x15a692374152d730722b91e456a7655da67e6cc6bed8dbca226a994b137c2d5
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x686be85fc524790e7420816a1ff03c9ee6b8c1b1410a0a3a641dcb668ffae30,
                    right: 0xe02030368f243cd44bd8c4eabfac4fe0a127b47591d33b9371fd51b78268f2
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x21fee98f67934fb82d3ef489a4c53e77ce9f3b01ece6aa4978752cac5f8042a,
                    right: 0x6fa68305a36dc8e20f40c11815672f846ed2c3dbd8a5f527bfb75d260486134
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x1638f743e26ae19e92928badffefe6199c787afd083b7530f902c80ff04e53e,
                    right: 0x5fe2eb6959c00ffd44a7bc1107495e0fd04717647e6f09ae45ceea956aa6e81
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x7b36421fb35533f713cd2839950fafbdb62c47557c33cf8d79b052a2ef71206,
                    right: 0x19a48ae2b606660ae0a496745ba0ffe35b4116e418bba34dfe5f4e4386d7bb
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x2847713ab79d7bb97779063f1badc1178e07e2a7850d6f45dd16c6f4451b4bd,
                    right: 0x490e359031000933da4114544ace5625a955a032305cf5a517bebddb2751fdd
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x6bf9a34258f061fde1d3a6bf9245c4b42618c7fcf0186a7bcca379c322bf914,
                    right: 0x29165b482661361a2224235740b26f95709b321e2892199a6ffb1539da3307f
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x28ea9c3558845d809991b5dc4e7c9ea3347af171e4bbb62e11854675f4826d0,
                    right: 0x37f320fc9e6aa382adc48b8ce12bc606c10d7e8a04e01e2bc473ca40adbedb0
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x2355253007b1d41323c1828cd6fe1a00336f2383c3e9cc0d7b8b872988fb884,
                    right: 0x2563398bac83121a77106ce1bd50b3bc18e8cd1e7cc10324704d2807087918c
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0xeb0ee7e6a76354ac47e9df7240a8bb2983ec7efa60e6f5671de52af868536e,
                    right: 0x150b036c82d75c35333da069f4d31f7e17ad1047d7313d7910608b7f77834e8
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x5305e4c236c643d1b476276ff1603f05b1f50d0ed84be3a6aedbcd67451f65a,
                    right: 0x43f9dc46167e6bb89dbccc090737da9a6f89b95f13494ee4aada84d7a34719f
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x1afca82e92f61a3a34b727099d50bf50600417ed43bf311e769bc64680ffbec,
                    right: 0x4537c2a080f9c474e5d51b37639b647483e800dc2e2b2eb7e03e62d20d2d83
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x69a2040f66673a2491f6990b05ee7e8e2ab236ce5cf02054a90c352be2dc2dc,
                    right: 0x653462e07b2fb1a50c26e1d17f663cfeb65207909e98f176c8872ff3af517f7
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x18149c74e19e4c84d830ec059432f7bd1c34bf6a58c13747180bc873e8cd9dc,
                    right: 0x7193545a5970aa22f11cd1a44abc2c5cbf97240a3f433e79b01bc34c62c0b5a
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x13888bc0cd202a0b72b7fabd09ab2012d35d78dd3d82743e9718b2415ab4abb,
                    right: 0x293d082ada0e78e9a9f811b4c117abbb94c470055b25bed68aa4363b1707514
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x2858c395c9adb5b0b2ca930c395d21d928410a2e8b34543c86d0019155ace3,
                    right: 0x3caf37cf62c5059e2648d09615282f575b0953e83f3baf80db3053adf7a73d4
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x6bb411a1d70553c9093228a7586514b4b8056b2bc1c1d455a4383d39bd98b3b,
                    right: 0x1f08690c8b0d4f6a72f5b1d890fb1dfe118b8e68a1a0bd32233489508264f76
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x7162a468b32ad5c13762d7e9b43c4c1bd8608a5ada145205f25fa0f19ad4ab5,
                    right: 0x24146acb005f04a7f006e86b521601330be67d4a57767e0ae210c82dc40b4f9
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x8724a910d4019af466771d7769afbf7b3ba078ff8679f3f13cace53ab2fd1d,
                    right: 0x38afd3c1f3fe3d979dbe9a6337220ca91fa78eddc3e71e8356002a3ae5dc8c3
                }
            ),
            TrieNode::Binary(
                BinaryNode {
                    left: 0x1d1397a2a45c062d67e9c2e3ca1634974e103c8366caea78ce7c8938c34aa48,
                    right: 0x11a708f6edd653f10dc7c185094018d66d6b3bf1bc4b10e928f6585806e7756
                }
            ),
            TrieNode::Edge(
                EdgeNode {
                    path: 0x221cb83fa859dbdb4c44beeaa0bb37c7537ad5ae66fe5e0efd20e6eb3,
                    length: 229,
                    child: 0x40a8a4f2c463e1efafb4180972c99b2550dbe2108359f085c82a29093ba26b8
                }
            )
        ],
        contract_data: ContractData {
            class_hash: 0x1cb96b938da26c060d5fd807eef8b580c49490926393a5eeb408a89f84b9b46,
            nonce: 0,
            contract_state_hash_version: 0,
            storage_proof: array![
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x145c5dbced84285e43d801c8f5349534673b955efe0b6fdca0a7d685f9245e7,
                        right: 0x2235f76ca299391243af777d67ec2c368e96b6f86917fa583198632dbe1327c
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x2bbf27bd54a516335d13097552ee35689091c027e4e506fd68eea063de13094,
                        right: 0x90c99201bb32cdd9f337de0879a92bf39b0b3d9861fffbf00b4a2f386c183e
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x1878cdb38eab1575881932dfde14468e876b72f7ab98f14e898ad807614e87e,
                        right: 0x7641e8d9fb6468493dc3890020bd1cdc2699318450c982433a7656d98caf38b
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x2ef8791e4da7b9d702f3ff82d63928cf21eb116cb528ec2dde837c7e3a5adf0,
                        right: 0x1038189cf32390acbfb932ed8bf797b917658b21c773cd0f906f0366e7d5368
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x33b0e9ca96fee6464cbcffc13346c664205f5d197a60affee579c613e6dfb2b,
                        right: 0x175d5e97a34015437acebf9bf1d932309cf00dd0380e7bd6891387dc96512d2
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x4d1a932bf61ed43b7eaee3419d5283eaf18978472a631229c447db5ce0000da,
                        right: 0x5170cc08550516a1aba2f98eea8d7a95cd504ab50b979ab4c64740b81a2fb52
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x78547d40f0d64cb611558dd829624de5dc2698d6e92ff5964d04eebbe2eb15d,
                        right: 0x5ea476ee6b61785a23adcd421bca8bc535d4a25e63cb8ce07086ef43fc87422
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x401e3f546acfa64a558d05e1b174a2188877cf747f057064638706dbd213662,
                        right: 0xcae7fcdc7b4d1fc8116716e5a15ee2a13b5837a33e95f2a3508cbd4e3dc491
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x1a2d607beaad9f5a6c70ecf824ae5873ab22438899f9566f6e55d706c8ae3fd,
                        right: 0x11eb48e5dbbbb49bd4ac6579ef805f4296fc0850d13725976a7945a5756267
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x40e96131048055ba373635fc0cdd824c638bde69989b69af61a67025c5cd07b,
                        right: 0x37a749fe989cff3a126cb5e589998728e5597808181b843d026d7c634c071fe
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x2ba7b528b2267e6c0a6209d07330df1c6f7ee30d79ada08d607597f2a3dc042,
                        right: 0xee57af4dd81c12005ebdd4b275271e4e54212278b3aac195f5f67d0cac0c9a
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x1da98e72a601959d20623c1fb620673c2898140c495de1087e9201739cb8864,
                        right: 0x74da25e69205d67a648137f9fbf73922223a8b6f753f99eec27f879f4a19ff6
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x2f2cb6a3912fe2c2ed41c902930eec4141e4d634bfff2774a5d92b9b3c6ab3b,
                        right: 0x74dd01540f64bec7d860954a6a1a7db1346c9ecc8899091cd1da0dd06c66ec3
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x4736efbf0a15520a228033700a2e81ef75427773c1db34646c50d642eaec59d,
                        right: 0x5f93f9fab28f48b3db62a31a105ba0aa12af11575f971a149dea781ccf7ed19
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x76e6cdb1d080e4b6a4a8b495f8a02dd970ee078d3698c6c0df891da03f08f53,
                        right: 0x510054b1300df68633ca91cfaa60e13a90382a91b11f14137addea19bd97037
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x174a1086208e9e05407451f141f73e8fdde9ffad1232e54f23caa926d732aff,
                        right: 0x7fc9d9a3c67cf86691cb9e1c662ef1f052697dba19aac60e5b83cfb777ff74c
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0xe07d592af92ceaecb991e0a28edd3bbe9bf304317f5ca75dee6decf9607a6e,
                        right: 0x12842effc2e3ad5ef995ec99f002b6540049f1368187625c08086a83523fe73
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0xae21ffc18a832bddc60f3e26160f9ff27d61b58337ed10b3eb6b53952c078d,
                        right: 0x1675b699989d5e0bd5630ac4686bf9366bb9d0160af03f81db023cf725cd9f2
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x2034cbbf4f63ccbb0d77990d4ac7c6a481ee4601d2753491d8e8cd60e80ae0,
                        right: 0x7b8d397e53c7e97d4fea66512a7cdfc2613b1225bd81cb5505954c476e9a93c
                    }
                ),
                TrieNode::Edge(
                    EdgeNode {
                        path: 0x1,
                        length: 1,
                        child: 0x1c5f3e73c9e969b9c5a621955d4813de68ca42a777fd4915ac5e71a73219893
                    }
                ),
                TrieNode::Binary(
                    BinaryNode {
                        left: 0x59e2516845b39a0f0771e257685ac06e3c3f1f479825521be982162dd249b24,
                        right: 0x1e4a53612070bf13d7677c61cb5448713d8479d57fba3d50059227d57ba0522
                    }
                ),
                TrieNode::Edge(
                    EdgeNode {
                        path: 0x108cd202d1472587dfe63dbf2d5ec767cbf4218b59b7ab71956780c6ee,
                        length: 230,
                        child: 0x78bc9be7c9e60005
                    }
                )
            ]
        }
    };
    let value = verify(state_commitment, contract_address, storage_address, proof);
    assert(expected_value == value, 'wrong value');
}
