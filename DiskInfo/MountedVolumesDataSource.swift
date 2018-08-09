
import Cocoa

class Section {

  class Item {
    let volume: VolumeInfo
    init(item: VolumeInfo) {
      self.volume = item
    }
  }

  let name: String
  let items: [Item]

  init(name: String, volumes: [VolumeInfo]) {
    self.name = name
    items = volumes.map {
      Item(item: $0)
    }
  }
}

class MountedVolumesDataSource: NSObject {

  var sections = [Section]()
  fileprivate var outlineView: NSOutlineView

  init(outlineView: NSOutlineView) {
    self.outlineView = outlineView
    super.init()
    self.outlineView.dataSource = self
  }

  func reload() {
    let mountedVolumes = VolumeInfo.mountedVolumes()

    let internalVolumes = mountedVolumes.filter {
      !$0.removable
      }.sorted {
        $0.name < $1.name
    }

    let removableVolumes = mountedVolumes.filter {
      $0.removable
      }.sorted {
        $0.name < $1.name
    }

    sections = [Section(name: "Internal", volumes: internalVolumes),
                Section(name: "Removable", volumes: removableVolumes)]

    outlineView.reloadData()
  }
}

extension MountedVolumesDataSource: NSOutlineViewDataSource {

  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    if item == nil {
      return sections.count
    } else if let section = item as? Section {
      return section.items.count
    } else {
      return 0
    }
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if let section = item as? Section {
      return section.items[index]
    } else {
      return sections[index]
    }
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return item is Section
  }
}
