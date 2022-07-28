//
//  DirectoryTreeStringFactory.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 27/07/2022.
//

import Foundation

/// Creates a pretty string from a `DirectoryTreeNode` and its child nodes.
private struct DirectoryTreeStringFactory {
    let node: DirectoryTreeNode

    /// Whether the full path of the node should be printed or just the name.
    var printFullPath: Bool = false

    /// The indent to apply, used during recursive looping over the nodes.
    var indent: String = ""

    /// Whether this node should be handled as a last node.
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
            .joined()
    }
}

extension DirectoryTreeNode: CustomStringConvertible {
    /// Formats the nodes into a readable pretty string.
    var description: String {
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
