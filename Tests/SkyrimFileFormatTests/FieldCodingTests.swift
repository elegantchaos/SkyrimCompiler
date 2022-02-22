// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 22/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import XCTest
import XCTestExtensions
@testable import SkyrimFileFormat

class FieldCodingTests: ProcessorTestCase {
    func testAlternateTexture() throws {
        let data = Data([
            0x04, 0x00, 0x00, 0x00, // size 4
            0x54, 0x65, 0x73, 0x74, // "Test"
            0x01, 0x02, 0x03, 0x04, // FormID 0x04030201
            0x0F, 0x00, 0x00, 0x00  // 3d index 0x0F
        ])
        
        let decoder = DataDecoder(data: data)
        let decoded = try decoder.decode(AlternateTextureField.AlternateTexture.self)
        XCTAssertEqual(decoded.name, "Test")
        XCTAssertEqual(decoded.texture.id, 0x04030201)
        XCTAssertEqual(decoded.index, 0xF)
        XCTAssertEqual(decoder.remainingCount(), 0)
        
        let encoder = DataEncoder()
        let encoded = try encoder.encode(decoded)
        XCTAssertEqual(data, encoded)
        
        let json = asJSON(decoded)
        XCTAssertEqual(json,
                        """
                        {
                          "index" : 15,
                          "name" : "Test",
                          "texture" : "0x04030201"
                        }
                        """
        )
        
        let decodedFromJSON = decode(AlternateTextureField.AlternateTexture.self, fromJSON: json)
        XCTAssertEqual(decoded, decodedFromJSON)
    }
    
    func testAlternateTextures() throws {
        let data = Data([
            0x01, 0x00, 0x00, 0x00, // count 1
            0x04, 0x00, 0x00, 0x00, // size 4
            0x54, 0x65, 0x73, 0x74, // "Test"
            0x01, 0x02, 0x03, 0x04, // FormID 0x04030201
            0x0F, 0x00, 0x00, 0x00  // 3d index 0x0F
        ])
        
        let decoder = DataDecoder(data: data)
        let decoded = try decoder.decode(AlternateTextureField.self)
        XCTAssertEqual(decoded.textures.count, 1)
        let texture = decoded.textures.first!
        XCTAssertEqual(texture.name, "Test")
        XCTAssertEqual(texture.texture.id, 0x04030201)
        XCTAssertEqual(texture.index, 0xF)
        XCTAssertEqual(decoder.remainingCount(), 0)
        
        let encoder = DataEncoder()
        let encoded = try encoder.encode(decoded)
        XCTAssertEqual(data, encoded)

        let json = asJSON(decoded)
        XCTAssertEqual(json,
                        """
                        {
                          "textures" : [
                            {
                              "index" : 15,
                              "name" : "Test",
                              "texture" : "0x04030201"
                            }
                          ]
                        }
                        """
        )
        
        let decodedFromJSON = decode(AlternateTextureField.self, fromJSON: json)
        XCTAssertEqual(decoded, decodedFromJSON)

    }
    
    func testBOD2Field() throws {
        let data = Data([
            0x01, 0x40, 0x10, 0x00, // flags 0x00104001 head, addOn3, decapitateHead
            0x02, 0x00, 0x00, 0x00, // clothing
        ])
        
        let decoder = DataDecoder(data: data)
        let decoded = try decoder.decode(BOD2Field.self)
        XCTAssertEqual(decoded.partFlags, [.head, .addOn3, .decapitateHead])
        XCTAssertEqual(decoded.armorType, .clothing)
        
        let encoder = DataEncoder()
        let encoded = try encoder.encode(decoded)
        XCTAssertEqual(data, encoded)

        let json = asJSON(decoded)
        XCTAssertEqual(json,
                        """
                        {
                          "armorType" : "clothing",
                          "partFlags" : [
                            "head",
                            "addOn3",
                            "decapitateHead"
                          ]
                        }
                        """
        )
        
        let decodedFromJSON = decode(BOD2Field.self, fromJSON: json)
        XCTAssertEqual(decoded, decodedFromJSON)

    }
    
    
    func testDecalData() throws {
        print(Float32(8.0).littleEndianBytes.map({ String(format: "%0X", $0)}))
        let data = Data([
            0x00, 0x00, 0x00, 0x00, // 0.0
            0x00, 0x00, 0x80, 0x3F, // 1.0
            0x00, 0x00, 0x00, 0x00, // 0.0
            0x00, 0x00, 0x80, 0x3F, // 1.0
            0x00, 0x00, 0x00, 0x40, // 2.0
            0x00, 0x00, 0x80, 0x40, // 4.0
            0x00, 0x00, 0x00, 0x41, // 8.0
            0x01,
            0xF0,
            0x00,
            0x00,
            0x00, 0xFF, 0xFF, 0xFF
        ])
        
        let decoder = DataDecoder(data: data)
        let decoded = try decoder.decode(DecalData.self)
        XCTAssertEqual(decoded.minWidth, 0.0)
        XCTAssertEqual(decoded.maxWidth, 1.0)
        XCTAssertEqual(decoded.minHeight, 0.0)
        XCTAssertEqual(decoded.maxHeight, 1.0)
        XCTAssertEqual(decoded.depth, 2.0)
        XCTAssertEqual(decoded.shininess, 4.0)
        XCTAssertEqual(decoded.parallaxScale, 8.0)
        XCTAssertEqual(decoded.parallaxPasses, 1)
        XCTAssertEqual(decoded.flags, 0xF0)
        XCTAssertEqual(decoded.unknown1, 0)
        XCTAssertEqual(decoded.unknown2, 0)
        XCTAssertEqual(decoded.rgb, .init(alpha: 0, red: 255, green: 255, blue: 255))

        let encoder = DataEncoder()
        let encoded = try encoder.encode(decoded)
        XCTAssertEqual(data, encoded)

        let json = asJSON(decoded)
        XCTAssertEqual(json,
                        """
                        {
                          "depth" : 2,
                          "flags" : 240,
                          "maxHeight" : 1,
                          "maxWidth" : 1,
                          "minHeight" : 0,
                          "minWidth" : 0,
                          "parallaxPasses" : 1,
                          "parallaxScale" : 8,
                          "rgb" : {
                            "alpha" : 0,
                            "blue" : 255,
                            "green" : 255,
                            "red" : 255
                          },
                          "shininess" : 4,
                          "unknown1" : 0,
                          "unknown2" : 0
                        }
                        """
        )
        
        let decodedFromJSON = decode(DecalData.self, fromJSON: json)
        XCTAssertEqual(decoded, decodedFromJSON)

    }
}
