//
//  GetDataMessageTests.swift
//  BitcoinSwift
//
//  Created by James MacWhyte on 8/23/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import XCTest

class GetDataMessageTests: XCTestCase {

  let getDataMessageBytes: [UInt8] = [
      0x01,                                           // Number of inventory vectors (1)
      0x02, 0x00, 0x00, 0x00,                         // First vector type (2: Block)
      0x71, 0x40, 0x03, 0x91, 0x50, 0x8c, 0xae, 0x45, // Block hash
      0x35, 0x86, 0x4f, 0x74, 0x91, 0x76, 0xab, 0x7f,
      0xa3, 0xa2, 0x51, 0xc2, 0x13, 0x40, 0x21, 0x1e,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

  var getDataMessageData: NSData!
  var getDataMessage: GetDataMessage!

  override func setUp() {
    super.setUp()
    getDataMessageData = NSData(bytes: getDataMessageBytes, length: getDataMessageBytes.count)
    let vectorHashBytes: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1e, 0x21, 0x40, 0x13, 0xc2, 0x51, 0xa2, 0xa3,
        0x7f, 0xab, 0x76, 0x91, 0x74, 0x4f, 0x86, 0x35,
        0x45, 0xae, 0x8c, 0x50, 0x91, 0x03, 0x40, 0x71] // Block hash.
    let vectorHash = SHA256Hash(bytes: vectorHashBytes)
    let inventoryVectors = [InventoryVector(type:.Block, hash: vectorHash)]
    getDataMessage = GetDataMessage(inventoryVectors: inventoryVectors)
  }

  func testGetDataMessageEncoding() {
    XCTAssertEqual(getDataMessage.bitcoinData, getDataMessageData)
  }

  func testGetDataMessageDecoding() {
    let stream = NSInputStream(data: getDataMessageData)
    stream.open()
    if let testGetDataMessage = GetDataMessage.fromBitcoinStream(stream) {
      XCTAssertEqual(testGetDataMessage, getDataMessage)
    } else {
      XCTFail("Failed to parse GetDataMessage")
    }
    XCTAssertFalse(stream.hasBytesAvailable)
    stream.close()
  }
}
