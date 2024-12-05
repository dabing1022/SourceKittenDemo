import Foundation
import XcodeKit
import Cocoa

class FileURLExtension: NSObject, XCSourceEditorExtension {
    // Extension入口
}

class FileURLCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, 
                 completionHandler: @escaping (Error?) -> Void) {
        
        guard let lines = invocation.buffer.lines as? [String],
              let selections = invocation.buffer.selections as? [XCSourceTextRange],
              let selection = selections.first else {
            completionHandler(nil)
            return
        }
        
        // 处理文件 URL 点击
        let currentLine = lines[selection.start.line]
        if let range = findFileURLRange(in: currentLine, at: selection.start.column) {
            let urlString = String(currentLine[range])
            handleFileURL(urlString)
        }
        
        completionHandler(nil)
    }
    
    private func handleFileURL(_ urlString: String) {
        let path = urlString.replacingOccurrences(of: "file://", with: "")
        
        DispatchQueue.main.async {
            if let url = URL(string: urlString) {
                if FileManager.default.fileExists(atPath: path) {
                    NSWorkspace.shared.open(url)
                } else {
                    showFileNotFoundAlert(path: path)
                }
            }
        }
    }
    
    private func showFileNotFoundAlert(path: String) {
        let alert = NSAlert()
        alert.messageText = "File Not Found"
        alert.informativeText = "The file at path '\(path)' does not exist."
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    private func findFileURLRange(in text: String, at index: Int) -> Range<String.Index>? {
        let pattern = "file://[^\\s)>\"']+"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        
        let nsRange = NSRange(location: 0, length: text.utf16.count)
        let matches = regex.matches(in: text, range: nsRange)
        
        for match in matches {
            if let range = Range(match.range, in: text),
               let startIndex = text.index(text.startIndex, offsetBy: index, limitedBy: text.endIndex),
               range.contains(startIndex) {
                return range
            }
        }
        return nil
    }
}

// 添加鼠标事件处理
extension FileURLCommand {
    private func handleMouseHover(at point: NSPoint, in textView: NSTextView) {
        guard let layoutManager = textView.layoutManager,
              let container = textView.textContainer else { return }
        
        let index = layoutManager.characterIndex(for: point, 
                                               in: container, 
                                               fractionOfDistanceBetweenInsertionPoints: nil)
        
        if let range = findFileURLRange(in: textView.string, at: index) {
            let nsRange = NSRange(range, in: textView.string)
            
            // 添加下划线样式
            let attributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: NSColor.blue
            ]
            
            textView.textStorage?.addAttributes(attributes, range: nsRange)
            
            // 改变鼠标样式
            NSCursor.pointingHand.set()
        } else {
            NSCursor.arrow.set()
        }
    }
}