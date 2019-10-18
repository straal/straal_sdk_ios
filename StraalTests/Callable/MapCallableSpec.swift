//
/*
 * MapCallableSpec.swift
 * Created by Michał Dąbrowski on 18/10/2019.
 *
 * Straal SDK for iOS
 * Copyright 2019 Straal Sp. z o. o.
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

class MapCallableSpec: QuickSpec {
	override func spec() {
		describe("MapCallable") {

			it("should correctly map simple callable") {
				expect { try MapCallable(SimpleCallable.init(10)) { $0 * 2 }.call() }.to(equal(20))
			}

			it("should not call the callable on creation") {
				let spy = CallableSpy()
				_ = MapCallable(spy) { $0 + 100 }
				expect(spy.callCount).to(equal(0))
			}

			it("should not call the callable after being called") {
				let spy = CallableSpy()
				_ = try? MapCallable(spy) { $0 + 100 }.call()
				expect(spy.callCount).to(equal(1))
			}
		}
	}
}
