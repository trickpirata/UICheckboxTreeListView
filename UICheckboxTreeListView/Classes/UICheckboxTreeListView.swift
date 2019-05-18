//
//  UICheckboxTreeListView.swift
//  UICheckboxTreeListView
//
//  Created by Patrick Gorospe on 5/17/19.
//

import Foundation
import KJExpandableTableTree

public class UICheckboxTreeListView: UIView {
   
    public lazy var treeView: KJTree = KJTree()
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private var checkedNodes = [Node]()
    private var nodes = [UICheckboxParent]()
    
    private var checkAll = false
    
    private func setupUI() {
         var c = [Child]()
        let childL3 = Child(key: "Level 3") { () -> [Child] in
            for index in 0...3 {
                c.append(Child(key: "Extra Child \(index)"))
            }
            return c
        }
        let childL2 = Child(key: "Level 2", expanded: true) { () -> [Child] in
            return [childL3]
        }
        
        
        let parentL1 = Parent(key: "Level 1", expanded: true) { () -> [Child] in
            return [childL2]
        }
        
        let p = UICheckboxParent(isChecked: false, node: parentL1, children: [childL2])
        let p2 = UICheckboxParent(isChecked: false, node: childL2, children: [childL3])
        let p3 = UICheckboxParent(isChecked: false, node: childL2, children: c)
        
        nodes = [p,p2,p3]
        treeView = KJTree(Parents: [parentL1])
        
        treeView.isInitiallyExpanded = true
        addSubview(tableView)
        tableView.register(UINib(nibName: "UICheckboxParentCell", bundle: Bundle.Assets), forCellReuseIdentifier: "UICheckboxParentCell")
        
        tableView.register(UINib(nibName: "UICheckboxChildCell", bundle: Bundle.Assets), forCellReuseIdentifier: "UICheckboxChildCell")
        
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}

extension UICheckboxTreeListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = treeView.tableView(tableView, didSelectRowAt: indexPath)
        node.state = .close
    }
}

extension UICheckboxTreeListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treeView.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = treeView.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
//        print(node.index)
        // You can return different cells for Parents, childs, subchilds, .... as below.
        var cell: UITableViewCell?

        let indexTuples = node.index.components(separatedBy: ".")
        if indexTuples.count == 1{ //level 1
            let c = tableView.dequeueReusableCell(withIdentifier: "UICheckboxParentCell") as! UICheckboxParentCell
            c.lblTitle.text = node.key
            setButtonState(c.btnAction, forNode: node)
            c.viewCheckBox.status = self.checkAll ? .active : .inactive
            if checkedNodes.contains(where: { (n) -> Bool in
                return n.index == node.index
            }) {
                c.viewCheckBox.status = .active
            }
            
            c.viewCheckBox.valueChanged = { [weak self](value) in
                guard let `self` = self else {
                    return
                }
                if value == .active {
                    self.checkedNodes.append(node)
                    
                } else {
                    self.checkedNodes.removeAll(where: { (n) -> Bool in
                        return n.index == node.index
                    })
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            
            cell = c
        } else if indexTuples.count == 2 { //level 2
            let c = tableView.dequeueReusableCell(withIdentifier: "UICheckboxChildCell") as! UICheckboxChildCell
            c.lblTitle.text = node.key
            c.contraintRightMargin.constant = 25
            c.updateConstraints()
            setButtonState(c.btnAction, forNode: node)
            c.viewCheckbox.status = self.checkAll ? .active : .inactive
            if checkedNodes.contains(where: { (n) -> Bool in
                return n.index == node.index || n.index.components(separatedBy: ".").count < 2
            }) {
                c.viewCheckbox.status = .active
            }
            c.viewCheckbox.valueChanged = { [weak self](value) in
                guard let `self` = self else {
                    return
                }
                if value == .active {
                    self.checkedNodes.append(node)
                } else {
                    self.checkedNodes.removeAll(where: { (n) -> Bool in
                        return n.index == node.index
                    })
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            if checkAll {
                c.viewCheckbox.status = .active
            }
            cell = c
        } else if indexTuples.count == 3 { //level 3
            let c = tableView.dequeueReusableCell(withIdentifier: "UICheckboxChildCell") as! UICheckboxChildCell
            c.lblTitle.text = node.key
            c.contraintRightMargin.constant = 40
            c.updateConstraints()
            setButtonState(c.btnAction, forNode: node)
            c.viewCheckbox.status = self.checkAll ? .active : .inactive
            if checkedNodes.contains(where: { (n) -> Bool in
                return n.index == node.index || n.index.components(separatedBy: ".").count < 3
            }) {
                c.viewCheckbox.status = .active
            }
            c.viewCheckbox.valueChanged = { [weak self](value) in
                guard let `self` = self else {
                    return
                }
                if value == .active {
                    self.checkedNodes.append(node)
                } else {
                    self.checkedNodes.removeAll(where: { (n) -> Bool in
                        return n.index == node.index
                    })
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            if checkAll {
                c.viewCheckbox.status = .active
            }
            cell = c
        }
        else {
            let c = tableView.dequeueReusableCell(withIdentifier: "UICheckboxChildCell") as! UICheckboxChildCell
            c.lblTitle.text = node.key
            c.contraintRightMargin.constant = 60
            c.updateConstraints()
            setButtonState(c.btnAction, forNode: node)
            c.btnAction.isHidden = true
            c.viewCheckbox.status = self.checkAll ? .active : .inactive
            if checkedNodes.contains(where: { (n) -> Bool in
                return n.index == node.index || n.index.components(separatedBy: ".").count < 4
            }) {
                c.viewCheckbox.status = .active
            }

            c.viewCheckbox.valueChanged = { [weak self](value) in
                guard let `self` = self else {
                    return
                }
                if value == .active {
                    self.checkedNodes.append(node)
                } else {
                    self.checkedNodes.removeAll(where: { (n) -> Bool in
                        return n.index == node.index
                    })
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            if checkAll {
                c.viewCheckbox.status = .active
            }
            cell = c
        }
        
       
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
        let c = UICheckBox(frame: .zero)
        c.status = self.checkAll ? .active : .inactive
        let lbl = UILabel(frame: .zero)
        lbl.text = "Select All"
        v.addSubview(c)
        v.addSubview(lbl)
        
        c.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(6)
            maker.centerY.equalToSuperview()
            maker.height.width.equalTo(20)
        }
        
        lbl.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(c)
            maker.left.equalTo(c.snp_rightMargin).offset(10)
            maker.right.equalToSuperview().offset(-10)
        }
        
        c.valueChanged = { [weak self](value) in
            guard let `self` = self else {
                return
            }
            self.checkAll = value == .active
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        return v
    }
    
    private func setButtonState(_ button: UIButton,forNode node: Node) {
        if node.state == .open {
            button.setImage(UIImage(named: "btnMinus", in: Bundle.Assets, compatibleWith: nil), for: .normal)
        } else if node.state == .close {
            button.setImage(UIImage(named: "btnPlus", in: Bundle.Assets, compatibleWith: nil), for: .normal)
        } else {
            button.setImage(UIImage(named: "btnPlus", in: Bundle.Assets, compatibleWith: nil), for: .normal)
        }
    }
}

extension Bundle {
    static public var Assets = UICheckBoxAssets()
    
    static public func UICheckBoxAssets() -> Bundle {
        let bundle = Bundle(for: UICheckboxTreeListView.self)
        
        if let path = bundle.path(forResource: "UICheckboxTreeListView", ofType: "bundle") {
            return Bundle(path: path)!
        } else {
            return bundle
        }
    }
}

struct UICheckboxParent {
    var isChecked = false
    var node: Node?
    var children: [Child]?
}

struct UICheckboxListChild {
    var parentNode: UICheckboxParent?
    var siblings: [UICheckboxListChild]?
}


