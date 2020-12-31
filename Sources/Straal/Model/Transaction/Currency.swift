/*
 * Currency.swift
 * Created by Kajetan Dąbrowski on 10/10/2016.
 *
 * Straal SDK for iOS
 * Copyright 2020 Straal Sp. z o. o.
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

/// Represents a currency
public struct Currency: RawRepresentable, Codable {

	private enum ValidCurrency: String {
		case pln
		case usd
		case eur
	}

	public typealias RawValue = String

	/// Objects raw value. It's represented by a string
	public let rawValue: String

	public init?(rawValue: String) {
		guard let currency = ValidCurrency(rawValue: rawValue) else { return nil }
		self.rawValue = currency.rawValue
	}

	public init?(_ rawValue: String) {
		self.init(rawValue: rawValue)
	}

}

extension Currency: CustomStringConvertible {
	/// Description
	public var description: String {
		return rawValue
	}
}
