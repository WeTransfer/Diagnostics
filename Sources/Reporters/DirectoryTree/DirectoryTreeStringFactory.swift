//
//  DirectoryTreeStringFactory.swift
//  PrintDirectoryTree
//
//  Created by Antoine van der Lee on 27/07/2022.
//

import Foundation

private struct DirectoryTreeStringFactory {
    let node: DirectoryTreeNode
    var printFullPath: Bool = false
    var indent: String = ""
    var isLastNode: Bool = true

    func make() -> String {
        let name = printFullPath ? "\(node.path)/\(node.name)" : node.name
        let currentString = "\(indent)\(isLastNode ? "└── " : "+-- ")\(name)\n"

        guard let contents = node.contents else {
            return currentString
        }

        return currentString + contents.enumerated()
            .map { (idx, content) in
                let indent = "\(indent)\(isLastNode ? "    " : "|   ")"
                let isLastNode = idx == contents.count - 1
                let childFactory = DirectoryTreeStringFactory(
                    node: content,
                    printFullPath: printFullPath,
                    indent: indent,
                    isLastNode: isLastNode)
                return childFactory.make()
            }
            .joined(separator: "")
    }
}

extension DirectoryTreeNode: CustomStringConvertible {
    /// Formats the the FS structure as into a tree.
    public var description: String {
        DirectoryTreeStringFactory(
            node: self,
            isLastNode: true
        ).make()
    }

    func prettyString(printFullPath: Bool) -> String {
        DirectoryTreeStringFactory(
            node: self,
            printFullPath: printFullPath,
            isLastNode: true
        ).make()
    }
}
