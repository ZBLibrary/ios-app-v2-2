//
//  EquidsCollectionViewController.swift
//  My
//
//  Created by test on 15/11/24.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionCell"
struct DevicesZB {
    var Name=""
    var `Type`=""
    var isActivit=0//0我的设备，1活动，2促销
}
class EquidsCollectionViewController: UICollectionViewController {

    var arraydata=[DevicesZB]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title=loadLanguage("已有设备")
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.view.backgroundColor=UIColor.white
        // Register cell classes
        //通过Nib生成cell，然后注册 Nib的view需要继承 UICollectionViewCell
        self.collectionView?.register(UINib(nibName: "EquidsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
                self.collectionView?.allowsMultipleSelection = false//默认为NO,是否可以多选
        loaddatazb()
    }

    func cellClickFun(_ button:UIButton)
    {
        print(button.tag)
        //print(indexPath.row+indexPath.section*3)
        let tmpdevice=devices[button.tag] as! OznerDevice
        NotificationCenter.default.post(name: Notification.Name(rawValue: "currentSelectedDevice"), object: tmpdevice)
        
        let array=(CustomTabBarView.sharedCustomTabBar() as AnyObject).btnMuArr as NSMutableArray
        let button=array.object(at: 0) as! UIButton
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).touchDownAction(button)
    }
//    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        
//    }
    var devices:[AnyObject?]!
    func loaddatazb()
    {
        devices=OznerManager.instance().getDevices() as [AnyObject?]
        for i in 0..<devices.count
        {
            let tmpdevice=devices[i]  as! OznerDevice
            var tmpstruct=DevicesZB()
            tmpstruct.isActivit=tmpdevice.connectStatus()==Connected ? 0:1
            tmpstruct.Type=tmpdevice.type
            tmpstruct.Name=tmpdevice.settings.name
            arraydata.append(tmpstruct)
        }
        self.collectionView?.reloadData()
        
    }
    func back()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false

        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return arraydata.count/3+(arraydata.count%3>0 ? 1:0)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let lineNumber=(arraydata.count/3+(arraydata.count%3>0 ? 1:0))
        if lineNumber<=1
        {
            return arraydata.count
        }else
        {
            if section<(lineNumber-1)
            {
                return 3
            }
            else
            {
                
                return (arraydata.count%3==0 ? 3:arraydata.count%3)
            }
        }
        
        
        // #warning Incomplete implementation, return the number of items
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EquidsCollectionViewCell
        cell.equipNameLabel.text=arraydata[(indexPath as NSIndexPath).row+(indexPath as NSIndexPath).section*3].Name
        print((indexPath as NSIndexPath).row+(indexPath as NSIndexPath).section*3)
        cell.cellClick.tag=(indexPath as NSIndexPath).row+(indexPath as NSIndexPath).section*3
        cell.cellClick.addTarget(self, action: #selector(cellClickFun), for: .touchUpInside)
        var imgwhich=""
        switch(arraydata[(indexPath as NSIndexPath).row+(indexPath as NSIndexPath).section*3].Type)
        {
            
        case "CP001":
            imgwhich+="My_cup"
        case "MXCHIP_HAOZE_Water":
            imgwhich+="My_shuiji"
        case "SC001":
            imgwhich+="My_tantou"
        case "FLT001"://空净
            imgwhich+="My_kongjing_small"
        case "FOG_HAOZE_AIR"://wifi空净
            imgwhich+="My_kongjing_big"
        case "BSY001"://补水仪
            imgwhich+="My_bsy"
            
        default:
            //cell.equipImage.image=UIImage(named: "My_cup")
            break
        }
        cell.right_up.isHidden=true
        switch(arraydata[(indexPath as NSIndexPath).row+(indexPath as NSIndexPath).section*3].isActivit)
        {
        case 0:
            cell.right_up.isHidden=true
            break
        case 1:
            cell.right_up.isHidden=true
            //cell.right_up.setTitle(loadLanguage("活动"), forState: .Normal)
            imgwhich+="_gray"
            break
//        case 2:
//            cell.right_up.hidden=false
//            cell.right_up.setTitle(loadLanguage("促销"), forState: .Normal)
//            imgwhich+="_gray"
//            break
        default:
            break
        }
        cell.equipImage.image=UIImage(named: imgwhich)
        //cell.right_up.hidden=true
        // Configure the cell

        return cell
    }

    // MARK: UICollectionViewDelegate
    //定义每个UICollectionViewCell 的大小
    //override func colle
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: Screen_Width/3-10, height: 108)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
