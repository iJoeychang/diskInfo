
import Cocoa

class ViewController: NSViewController {

  fileprivate struct Constants {
    static let headerCellID = "HeaderCell"
    static let volumeCellID = "VolumeCell"
  }

  fileprivate var dataSource: MountedVolumesDataSource!
  fileprivate var delegate: MountedVolumesDelegate!
  fileprivate var bytesFormatter = ByteCountFormatter()

  @IBOutlet var outlineView: NSOutlineView!
  @IBOutlet var imageView: NSImageView!
  @IBOutlet var nameLabel: NSTextField!
  @IBOutlet var infoLabel: NSTextField!
  @IBOutlet weak var graphView: GraphView!

  override func viewDidLoad() {
    super.viewDidLoad()

    dataSource = MountedVolumesDataSource(outlineView: outlineView)
    delegate = MountedVolumesDelegate(outlineView: outlineView) { volume in
      self.showVolumeInfo(volume)
    }
  }

  override func viewWillAppear() {
    super.viewWillAppear()

    loadVolumes()
    selectFirstVolume()
  }

  func loadVolumes() {
    dataSource.reload()
    outlineView.expandItem(nil, expandChildren: true)
  }

  func selectFirstVolume() {
    guard let item = dataSource.sections.first?.items.first else {
      return
    }

    showVolumeInfo(item.volume)
    outlineView.selectRowIndexes(IndexSet(integer: outlineView.row(forItem: item)), byExtendingSelection: true)
  }

  func showVolumeInfo(_ volume: VolumeInfo) {
    imageView.image = volume.image
    nameLabel.stringValue = volume.name
    infoLabel.stringValue = "Capacity: \(bytesFormatter.string(fromByteCount: volume.capacity))." +
      "Available: \(bytesFormatter.string(fromByteCount: volume.available))"

    graphView.fileDistribution = volume.fileDistribution
  }
}
