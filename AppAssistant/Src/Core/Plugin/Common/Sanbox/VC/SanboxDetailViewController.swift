//
//  SanboxDetailViewController.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/19.
//

import QuickLook

class SanboxDetailViewController: UIViewController {

    private var imageView: UIImageView?

    private lazy var textView: UITextView = {

        let textView = UITextView(frame: self.view.bounds)
        textView.font = UIFont.regular(12)
        textView.textColor = UIColor.assistant_black_1()
        textView.textAlignment = .left
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.white
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 2.0
        return textView
    }()

    private var tableNameArray: [AnyObject]?
    private var dbTableNameTableView: UITableView?

    private var filePath: String?

    init(filePath: String) {
        self.filePath = filePath
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        assistant_setNavBack()
        assistant_setNavTitle(localizedString("文件预览"))
        guard let filePath = self.filePath else {
            return
        }

        if !filePath.isEmpty {
            let path = filePath
            if path.hasSuffix(".strings") || path.hasSuffix(".plist") {
                // 文本文件
                setContent(NSDictionary(contentsOfFile: path)?.description ?? "")
//            } else if path.hasSuffix(".DB") || path.hasSuffix(".db") || path.hasSuffix(".sqlite") || path.hasSuffix(".SQLITE") {
//                // 数据库文件
//                self.title = DoraemonLocalizedString("数据库预览")
//                self.browseDBTable()
            } else if path.lowercased().hasSuffix(".webp") {
                // webp文件
                // DoraemonWebpHandleBlock block = [DoraemonManager shareInstance].webpHandleBlock;
                // if (block) {
                //     UIImage *img = [DoraemonManager shareInstance].webpHandleBlock(path);
                //     [self setOriginalImage:img];
                // }else{
                //     [self setContent:@"webp need implement webpHandleBlock in DoraemonManager"];
                // }
            } else {
                // 其他文件 尝试使用 QLPreviewController 进行打开
                let previewController = QLPreviewController()
                previewController.view.backgroundColor = .white
                previewController.delegate = self
                previewController.dataSource = self
                self.present(previewController, animated: true)
            }
        } else {
            ToastUtil.showToast(localizedString("文件不存在"), superView: view)
        }
    }

    func setContent(_ text: String) {
        textView.text = text
        view.addSubview(textView)
    }

//    func setOriginalImage(_ originalImage: UIImage) {
//        if !originalImage {
//            return
//        }
//        var viewWidth: CGFloat = self.view.doraemon_width
//        var viewHeight: CGFloat = self.view.doraemon_height
//        var imageWidth: CGFloat = originalImage.size.width
//        var imageHeight: CGFloat = originalImage.size.height
//        var isPortrait: Bool = imageHeight/viewHeight > imageWidth/viewWidth
//        var scaledImageWidth: CGFloat
//        var scaledImageHeight: CGFloat
//        var x: CGFloat
//        var y: CGFloat
//        var imageScale: CGFloat
//        if isPortrait {
//            //图片竖屏分量比较大
//            imageScale = imageHeight/viewHeight
//            scaledImageHeight = viewHeight
//            scaledImageWidth = imageWidth/imageScale
//            x = (viewWidth-scaledImageWidth)/2
//            y = 0
//        } else {
//            //图片横屏分量比较大
//            imageScale = imageWidth/viewWidth
//            scaledImageWidth = viewWidth
//            scaledImageHeight = imageHeight/imageScale
//            x = 0
//            y = (viewHeight-scaledImageHeight)/2
//
//        }
//        _imageView = UIImageView(frame: CGRectMake(x, y, scaledImageWidth, scaledImageHeight))
//        _imageView.image = originalImage
//        _imageView.userInteractionEnabled = true
//        self.view.addSubview(_imageView)
//    }

//    //浏览数据库中所有数据表
//    func browseDBTable() {
//        DoraemonDBManager.shareManager().dbPath = self.filePath
//        self.tableNameArray = DoraemonDBManager.shareManager().tablesAtDB()
//        self.dbTableNameTableView = UITableView(frame: CGRectMake(0, 0, self.view.doraemon_width, self.view.doraemon_height), style: .plain)
//        //    self.dbTableNameTableView.backgroundColor = [UIColor whiteColor];
//        self.dbTableNameTableView.delegate = self
//        self.dbTableNameTableView.dataSource = self
//        self.view.addSubview(self.dbTableNameTableView)
//    }

//    // MARK: - UITableViewDelegate,UITableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.tableNameArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        private var identifer: String = "db_table_name"
//        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifer)
//        if !cell {
//            cell = UITableViewCell(style: .default, reuseIdentifier: identifer)
//        }
//        cell.textLabel.text = self.tableNameArray[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        var tableName: String = self.tableNameArray.object(at: indexPath.row)
//        DoraemonDBManager.shareManager().tableName = tableName
//        // DoraemonDBTableViewController *vc = [[DoraemonDBTableViewController alloc] init];
//        // [self.navigationController pushViewController:vc animated:YES];
//    }
}

extension SanboxDetailViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return NSURL(fileURLWithPath: filePath ?? "")
    }

    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        assistant_backBtnClick(sender: UIButton())
    }

}
