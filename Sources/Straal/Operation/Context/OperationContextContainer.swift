/*
 * OperationContextContainer.swift
 * Created by Michał Dąbrowski on 13/01/2021.
 *
 * Straal SDK for iOS
 * Copyright 2021 Straal Sp. z o. o.
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

protocol OperationContextContainer {
	var registered: [OperationContext] { get }
	func register(context: OperationContext)
	func unregister(context: OperationContext)
}

final internal class OperationContextContainerImpl: OperationContextContainer {

	static let shared: OperationContextContainer = OperationContextContainerImpl()

	private(set) var registered: [OperationContext] = []

	func register(context: OperationContext) {
		registered.append(context)
	}

	func unregister(context: OperationContext) {
		registered.removeAll(where: { $0 === context })
	}
}
