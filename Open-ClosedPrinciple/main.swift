//
//  main.swift
//  Open-ClosedPrinciple
//
//  Created by Cahyanto Setya Budi on 18/12/19.
//  Copyright © 2019 Cahyanto Setya Budi. All rights reserved.
//

import Foundation

enum Color {
    case red
    case green
    case blue
}

enum Size {
    case small
    case medium
    case large
    case huge
}

//Specification pattern
protocol Specification {
    associatedtype T
    
    func isSatisfied(_ item: T) -> Bool
}

protocol Filter {
    associatedtype T
    
    func filter<Spec: Specification>(_ items: [T], _ spec: Spec) -> [T] where Spec.T == T
}

class ColorSpecification: Specification {
    typealias T = Product
    
    let color: Color
    
    init(_ color: Color) {
        self.color = color
    }
    
    func isSatisfied(_ item: Product) -> Bool {
        return item.color == color
    }
}

class SizeSpecification: Specification {
    typealias T = Product
    
    let size: Size
    
    init(_ size: Size) {
        self.size = size
    }
    
    func isSatisfied(_ item: Product) -> Bool {
        return item.size == size
    }
}

class AndSpecification<T, SpecA: Specification, SpecB: Specification>: Specification where SpecA.T == T, SpecB.T == T {
    
    let first: SpecA
    let second: SpecB
    
    init(_ first: SpecA, _ second: SpecB) {
        self.first = first
        self.second = second
    }
    
    func isSatisfied(_ item: T) -> Bool {
        return first.isSatisfied(item) && second.isSatisfied(item )
    }
}

class FilterProduct: Filter {
    typealias T = Product
    
    func filter<Spec: Specification>(_ items: [Product], _ spec: Spec) -> [Product] where Spec.T == T {
        var result = [Product]()
        
        items.forEach { (product) in
            if spec.isSatisfied(product) {
                result.append(product)
            }
        }
        
        return result
    }
}

class Product {
    var name: String
    var color: Color
    var size: Size
    
    init(_ name: String, _ color: Color, _ size: Size) {
        self.name = name
        self.color = color
        self.size = size
    }
}

func main() {
    let apple = Product("Apple", .green, .small)
    let tree = Product("Tree", .green, .small)
    let flower = Product("Flower", .blue, .medium)
    
    let products = [apple, tree, flower]
    
    let searchProduct = FilterProduct()
    searchProduct.filter(products, ColorSpecification(.green))
        .forEach { (product) in
            print("\(product.name) is green")
        }
    
    searchProduct.filter(products, SizeSpecification(.small))
        .forEach { (product) in
            print("\(product.name) is small")
        }
    
    searchProduct.filter(products, AndSpecification(ColorSpecification(.green), SizeSpecification(.small)))
        .forEach { (product) in
            print("\(product.name) is \(product.color) and \(product.size)")
        }
}

main()
