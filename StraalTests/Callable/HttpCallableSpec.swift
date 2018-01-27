/*
 * HttpCallableSpec.swift
 * Created by Bartosz Kamiński on 25/01/2018.
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

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble

@testable import Straal

class HttpCallableSpec: QuickSpec {
	override func spec() {
		describe("HttpCallable") {
			var sut: HttpCallable!
			var urlSessionAdapterFake: UrlSessionAdapterFake!

			let url = URL(string: "https://straal.com/endpoint")!
			let request = URLRequest(url: url)
			let correctData = Data()
			let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.1", headerFields: nil)!

			beforeEach {
				urlSessionAdapterFake = UrlSessionAdapterFake()
			}

			afterEach {
				sut = nil
				urlSessionAdapterFake = nil
			}

			context("when data and response are correct") {

				var result: (Data, HTTPURLResponse)?

				beforeEach {
					urlSessionAdapterFake.synchronousDataTaskToReturn = (correctData, httpResponse, nil)
					sut = HttpCallable(requestSource: SimpleCallable.of(request), urlSession: urlSessionAdapterFake)
					result = try? sut.call()
				}

				it("session adapter should receive correct request") {
					expect(urlSessionAdapterFake.synchronousDataTaskCapturedRequest).to(equal(request))
				}

				it("should not throw error") {
					expect { try sut.call() }.notTo(throwError())
				}

				it("should return correct data and response") {
					expect(result?.0).to(equal(correctData))
					expect(result?.1).to(equal(httpResponse))
				}
			}

			context("when response isn't http") {

				let otherResponse = URLResponse(url: url, mimeType: "application/json", expectedContentLength: 10, textEncodingName: nil)

				beforeEach {
					urlSessionAdapterFake.synchronousDataTaskToReturn = (correctData, otherResponse, nil)
					sut = HttpCallable(requestSource: SimpleCallable.of(request), urlSession: urlSessionAdapterFake)
				}

				it("should throw Straal unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.unknown))
				}
			}

			context("when data is nil") {

				beforeEach {
					urlSessionAdapterFake.synchronousDataTaskToReturn = (nil, httpResponse, nil)
					sut = HttpCallable(requestSource: SimpleCallable.of(request), urlSession: urlSessionAdapterFake)
				}

				it("should throw Straal unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.unknown))
				}
			}

			context("when there's an error") {

				let error = StraalError.invalidResponse

				beforeEach {
					urlSessionAdapterFake.synchronousDataTaskToReturn = (nil, nil, error)
					sut = HttpCallable(requestSource: SimpleCallable.of(request), urlSession: urlSessionAdapterFake)
				}

				it("should throw the same error") {
					expect { try sut.call() }.to(throwError(error))
				}
			}
		}
	}
}
