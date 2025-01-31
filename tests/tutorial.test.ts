import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Can create new tutorial",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const block = chain.mineBlock([
      Tx.contractCall("tutorial", "create-tutorial", [
        types.utf8("Summer Skincare Routine"),
        types.utf8("Complete guide for summer skincare"),
        types.utf8("QmHash123"),
        types.uint(100),
        types.utf8("Skincare"),
      ], deployer.address),
    ]);
    assertEquals(block.receipts[0].result.expectOk(), "u1");
  },
});

Clarinet.test({
  name: "Can retrieve tutorial details",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    chain.mineBlock([
      Tx.contractCall("tutorial", "create-tutorial", [
        types.utf8("Summer Skincare Routine"),
        types.utf8("Complete guide for summer skincare"),
        types.utf8("QmHash123"),
        types.uint(100),
        types.utf8("Skincare"),
      ], deployer.address),
    ]);

    const block = chain.mineBlock([
      Tx.contractCall("tutorial", "get-tutorial", [
        types.uint(1)
      ], deployer.address),
    ]);
    assertEquals(block.receipts[0].result.expectOk().expectTuple()['title'], "Summer Skincare Routine");
  },
});
