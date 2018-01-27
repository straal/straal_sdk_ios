/*
 * AmericanExpressSpec.swift
 * Created by Bartosz Kamiński on 11/07/2017.
 *
 * Straal SDK for iOS Tests
 * Copyright 2018 Straal Sp. z o. o.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or  * implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import Quick
import Nimble

@testable import Straal

class AmericanExpressSpec: QuickSpec {
	override func spec() {
		describe("AmericanExpress") {

			var sut: AmericanExpress!

			beforeEach {
				sut = AmericanExpress()
			}

			afterEach {
				sut = nil
			}

			describe("Number validation") {

				it("should return valid for correct AmericanExpress card number") {
					expect(sut.validate(number: CardNumber(rawValue: "3400 0000 0000 009"))).to(equal(ValidationResult.valid))
					expect(sut.validate(number: CardNumber(rawValue: "340000000000009"))).to(equal(ValidationResult.valid))
					expect(sut.validate(number: CardNumber(rawValue: "3400-0000-0000-009"))).to(equal(ValidationResult.valid))
				}

				it("should return number not numeric for empty number") {
					expect(sut.validate(number: CardNumber(rawValue: ""))).to(equal(ValidationResult.numberIsNotNumeric))
				}

				it("should return number not numeric for non-numeric number") {
					expect(sut.validate(number: CardNumber(rawValue: "abc"))).to(equal(ValidationResult.numberIsNotNumeric))
				}

				it("should return incomplete for incomplete number") {
					expect(sut.validate(number: CardNumber(rawValue: "3400 0000"))).to(equal(ValidationResult.numberIncomplete))
				}

				it("should return too long for too long number") {
					expect(sut.validate(number: CardNumber(rawValue: "3400 0000 0000 009123"))).to(equal(ValidationResult.numberTooLong))
				}

				it("should return luhn test failed for incorrect number") {
					expect(sut.validate(number: CardNumber(rawValue: "3400 0005 0000 009"))).to(equal(ValidationResult.luhnTestFailed))
				}
			}

			describe("CVV validation") {

				it("should return valid for correct AmericanExpress CVV") {
					expect(sut.validate(cvv: CVV(rawValue: "1234"))).to(equal(ValidationResult.valid))
					expect(sut.validate(cvv: CVV(rawValue: "0057"))).to(equal(ValidationResult.valid))
				}

				it("should return invalid for empty CVV") {
					expect(sut.validate(cvv: CVV(rawValue: ""))).to(equal(ValidationResult.invalidCVV))
				}

				it("should return invalid for non-numeric CVV") {
					expect(sut.validate(cvv: CVV(rawValue: "abc"))).to(equal(ValidationResult.invalidCVV))
				}

				it("should return incomplete for too short CVV") {
					expect(sut.validate(cvv: CVV(rawValue: "123"))).to(equal(ValidationResult.incompleteCVV))
				}

				it("should return invalid for too long CVV") {
					expect(sut.validate(cvv: CVV(rawValue: "12345"))).to(equal(ValidationResult.invalidCVV))
				}
			}
		}
	}
}
