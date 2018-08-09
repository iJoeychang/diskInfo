

import Cocoa

typealias SelectionBlock = (_ volume: VolumeInfo) -> Void

class MountedVolumesDelegate: NSObject {
  
  var outlineView: NSOutlineView
  var volumeSelectionBlock: SelectionBlock?
  
  fileprivate struct Constants {
    static let headerCellID = "HeaderCell"
    static let volumeCellID = "VolumeCell"
  }
  
  init(outlineView: NSOutlineView, selectionBlock: @escaping SelectionBlock) {
    self.outlineView = outlineView
    self.volumeSelectionBlock = selectionBlock
    super.init()
    self.outlineView.delegate = self
  }
}

extension MountedVolumesDelegate: NSOutlineViewDelegate {
  
  func outlineViewSelectionDidChange(_ notification: Notification) {
    guard let outlineView = notification.object as? NSOutlineView else {
      return
    }
    let selectedRow = outlineView.selectedRow
    guard let item = outlineView.item(atRow: selectedRow) as? Section.Item , selectedRow >= 0 else {
      return
    }
    volumeSelectionBlock?(item.volume)
  }
  
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    var cell: NSTableCellView?
    
    if let section = item as? Section {
      cell = outlineView.make(withIdentifier: Constants.headerCellID, owner: self) as? NSTableCellView
      cell?.textField?.stringValue = section.name
    } else if let item = item as? Section.Item {
      cell = outlineView.make(withIdentifier: Constants.volumeCellID, owner: self) as? NSTableCellView
      cell?.textField?.stringValue = item.volume.name
      cell?.imageView?.image = item.volume.image
    }
    return cell
  }
  
  func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
    return item is Section
  }
  
  func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
    return !(item is section)
  }
}
