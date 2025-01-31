import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Can register new creator profile",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const block = chain.mineBlock([
      Tx.contractCall("creator-profile", "register-creator", [
        types.utf8("Alice Beauty"),
        types.utf8("Skincare expert with 5 years experience"),
        types.utf8("Skincare"),
      ], deployer.address),
    ]);
    assertEquals(block.receipts[0].result.expectOk(), true);
  },
});

Clarinet.test({
  name: "Cannot register same creator twice",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    chain.mineBlock([
      Tx.contractCall("creator-profile", "register-creator", [
        types.utf8("Alice Beauty"),
        types.utf8("Skincare expert"),
        types.utf8("Skincare"),
      ], deployer.address),
    ]);

    const block = chain.mineBlock([
      Tx.contractCall("creator-profile", "register-creator", [
        types.utf8("Alice Beauty 2"),
        types.utf8("Skincare expert 2"),
        types.utf8("Skincare"),
      ], deployer.address),
    ]);
    assertEquals(block.receipts[0].result.expectErr(), 100);
  },
});
