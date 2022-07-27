//
//  FSNode.swift
//  tree
//
//  Created by Peter Matta on 10/31/18.
//

import Foundation

/// A file system node with it's path, name and contents.
indirect enum DirectoryTreeNode {
    /// A regular file.
    case file(String, String)
    
    /// A symlink.
    case symbolLink(String, String)
    
    /// A directory with it's contents.
    case directory(String, String, [DirectoryTreeNode])
}

// MARK: - Accessors

extension DirectoryTreeNode {
    /// Returns file path to the file node.
    var path: String {
        switch self {
        case let .file(path, _),
            let .symbolLink(path, _),
            let .directory(path, _, _):
            return path
        }
    }
    
    /// Returns node's name.
    var name: String {
        switch self {
        case let .file(_, name),
            let .symbolLink(_, name),
            let .directory(_, name, _):
            return name
        }
    }
    
    /// Returns contents of the node, if the node is directory, `nil` otherwise.
    var contents: [DirectoryTreeNode]? {
        switch self {
        case let .directory(_, _, contents): return contents
        default: return nil
        }
    }
    
    /// Returns `true` if node is a directory, `false` otherwise.
    var isDirectory: Bool {
        switch self {
        case .directory: return true
        default: return false
        }
    }
    
    /// Returns `true` if node is a file, `false` otherwise.
    var isFile: Bool {
        switch self {
        case .file: return true
        default: return false
        }
    }
    
    /// Returns `true` if node is a symbolLink, `false` otherwise.
    var isSymbolLink: Bool {
        switch self {
        case .symbolLink: return true
        default: return false
        }
    }
}

// MARK: - Transformations

extension DirectoryTreeNode {
    /// Returns array of directory names.
    var directories: [String] {
        switch self {
        case .file, .symbolLink: return []
        case let .directory(_, name, contents):
            return [name] + contents.flatMap { $0.directories }
        }
    }
    
    /// Returns an array of file names existing in the FS tree.
    var files: [String] {
        switch self {
        case .symbolLink: return []
        case let .file(_, name): return [name]
        case let .directory(_, _, contents):
            return contents.flatMap { $0.files }.sorted()
        }
    }
}

extension DirectoryTreeNode: Equatable {
    static func == (lhs: DirectoryTreeNode, rhs: DirectoryTreeNode) -> Bool {
        switch (lhs, rhs) {
        case (let .file(lhsPath, lhsName), let .file(rhsPath, rhsName)):
            return lhsName == rhsName && lhsPath == rhsPath
        case (let .symbolLink(lhsPath, lhsName), let .symbolLink(rhsPath, rhsName)):
            return lhsName == rhsName && lhsPath == rhsPath
        case (let .directory(lhsPath, lhsName, lhsContent),
              let .directory(rhsPath, rhsName, rhsContent)):
            return lhsPath == rhsPath
            && lhsName == rhsName && lhsContent == rhsContent
        default:
            return false
        }
    }
}
