//
//  File.swift
//  
//
//  Created by Antoine van der Lee on 27/07/2022.
//

import Foundation

public struct DirectoryTreesReporter: DiagnosticsReporting {
    let title: String = "Directory Storage Trees"
    let directories: [URL]
    let maxDepth: Int
    let maxLength: Int
    let includeHiddenFiles: Bool
    let includeSymbolicLinks: Bool
    let printFullPath: Bool

    public init(
        directories: [URL],
        maxDepth: Int = .max,
        maxLength: Int = 10,
        includeHiddenFiles: Bool = false,
        includeSymbolicLinks: Bool = false,
        printFullPath: Bool = false
    ) {
        self.directories = directories
        self.maxDepth = maxDepth
        self.maxLength = maxLength
        self.includeHiddenFiles = includeHiddenFiles
        self.includeSymbolicLinks = includeSymbolicLinks
        self.printFullPath = printFullPath
    }

    public func report() -> DiagnosticsChapter {
        var diagnostics = ""

        for directory in directories {
            do {
                let directoryName = directory.lastPathComponent
                diagnostics.append("<h3>Directory Tree for: \(directoryName)</h3>")

                let tree = try DirectoryTreeFactory(
                    path: directory.path,
                    maxDepth: maxDepth,
                    maxLength: maxLength,
                    includeHiddenFiles: includeHiddenFiles,
                    includeSymbolicLinks: includeSymbolicLinks
                ).make()

                diagnostics.append("""
                <ul>
                    <li>Number of directories: \(tree.directories.count)</li>
                    <li>Number of files: \(tree.files.count)</li>
                </ul>
                """)
                diagnostics.append("""
                <pre>
                \(tree.prettyString(printFullPath: printFullPath))
                </pre>
                """)
            } catch {
                diagnostics.append("<p>Failed generating tree: \(error.localizedDescription)</p>")
            }
        }
        return DiagnosticsChapter(title: "Directory Trees", diagnostics: diagnostics, shouldShowTitle: false)
    }
}
