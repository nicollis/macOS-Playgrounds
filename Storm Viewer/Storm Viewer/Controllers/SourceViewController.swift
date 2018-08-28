//
//  SourceViewController.swift
//  Storm Viewer
//
//  Created by Nicholas Ollis on 8/26/18.
//

import Cocoa

class SourceViewController: NSViewController {
    @IBOutlet var tableView: NSTableView!
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get a list of all files in our bundle's resource path
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
    }
}

extension SourceViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pictures.count
    }
}

extension SourceViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let vw = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else {
            return nil
        }
        vw.textField?.stringValue = pictures[row]
        vw.imageView?.image = NSImage(named: NSImage.Name(pictures[row]))
        
        return vw
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1,
              let splitVC = parent as? NSSplitViewController else { return }
        
        if let detail = splitVC.childViewControllers[1] as? DetailViewController {
            detail.imageSelected(name: pictures[tableView.selectedRow])
        }
    }
}
