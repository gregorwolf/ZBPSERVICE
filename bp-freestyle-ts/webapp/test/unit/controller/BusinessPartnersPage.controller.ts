/*global QUnit*/
import Controller from "csw/bpfreestylets/controller/BusinessPartners.controller";

QUnit.module("BusinessPartners Controller");

QUnit.test(
  "I should test the BusinessPartners controller",
  function (assert: Assert) {
    const oAppController = new Controller("BusinessPartners");
    oAppController.onInit();
    assert.ok(oAppController);
  }
);
