//
//  Utilities.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import UniformTypeIdentifiers

extension NSItemProvider {
    func loadFileURL() async -> URL? {
        guard let data = try? await loadItem(forTypeIdentifier: UTType.fileURL.identifier) as? Data else {
            print("Can't load data for dropped item."); return nil
        }
        guard let url = URL(dataRepresentation: data, relativeTo: nil) else {
            print("Can't form URL from data for dropped item."); return nil
        }
        return url
    }
}
