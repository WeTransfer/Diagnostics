//
//  DirectoryTreeFactory.swift
//  PrintDirectoryTree
//
//  Created by Antoine van der Lee on 27/07/2022.
//

import Foundation

struct DirectoryTreeFactory {
    enum Error: Swift.Error {
        case invalidFileType
        case rootNodeCreationFailed
    }

    let path: String
    var maxDepth: Int = .max
    var maxLength: Int = 10
    var includeHiddenFiles: Bool = false
    var includeSymbolicLinks: Bool = false
    var fileManager: FileManager = .default

    func make() throws -> DirectoryTreeNode {
        guard let rootNode = try nodeFrom(path: path, depth: 0) else {
            throw Error.rootNodeCreationFailed
        }
        return rootNode
    }

    private func nodeFrom(path: String, depth: Int) throws -> DirectoryTreeNode? {
        guard depth < maxDepth else { return nil }
        let name = fileManager.displayName(atPath: path)
        guard includeHiddenFiles || !name.starts(with: ".") else {
            return nil
        }
        let type = try fileType(atPath: path)

        switch type {
        case .typeRegular: return .file(path, name)
        case .typeSymbolicLink:
            guard includeSymbolicLinks else { return nil }
            return .symbolLink(path, name)
        case .typeDirectory:
            let allContents = try fileManager
                .contentsOfDirectory(atPath: path)

            var contents = try allContents.prefix(maxLength)
                .compactMap { try nodeFrom(path: "\(path)/\($0)", depth: depth + 1) }
            if allContents.count > maxLength, !contents.isEmpty {
                let skippedFilesCount = allContents.count - maxLength
                contents.append(.file("", "\(skippedFilesCount) more file(s)"))
            }

            return .directory(path, name, contents)
        default:
            throw Error.invalidFileType
        }
    }

    /// Returns a type of file at the given path
    private func fileType(atPath path: String) throws -> FileAttributeType {
        let attr = try fileManager.attributesOfItem(atPath: path)
        let dict = NSDictionary(dictionary: attr)
        guard let type = dict.fileType() else {
            throw Error.invalidFileType
        }
        return FileAttributeType(rawValue: type)
    }
}
