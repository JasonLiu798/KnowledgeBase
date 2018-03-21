
# java事件处理机制（自定义事件）
java中的事件机制的参与者有3种角色：
1.event object：事件状态对象，用于listener的相应的方法之中，作为参数，一般存在与listerner的方法之中
2.event source：具体的事件源，比如说，你点击一个button，那么button就是event source，要想使button对某些事件进行响应，你就需要注册特定的listener。
3.event listener：对每个明确的事件的发生，都相应地定义一个明确的Java方法。这些方法都集中定义在事件监听者（EventListener）接口中，这个接口要继承 java.util.EventListener。 实现了事件监听者接口中一些或全部方法的类就是事件监听者。
　　伴随着事件的发生，相应的状态通常都封装在事件状态对象中，该对象必须继承自java.util.EventObject。事件状态对象作为单参传递给应响应该事件的监听者方法中。发出某种特定事件的事件源的标识是：遵从规定的设计格式为事件监听者定义注册方法，并接受对指定事件监听者接口实例的引用。

具体的对监听的事件类，当它监听到event object产生的时候，它就调用相应的方法，进行处理。

## jdk提供的event包
public interface EventListener：所有事件侦听器接口必须扩展的标记接口。
public class EventObject extends Object implements Serializable
所有事件状态对象都将从其派生的根类。 所有 Event 在构造时都引用了对象 "source"，在逻辑上认为该对象是最初发生有关 Event 的对象。

（1）通过DoorEvent.java文件创建DoorEvent类，这个类继承EventObject。
```java
/**
* 定义事件对象，必须继承EventObject
*/
public class DoorEvent extends EventObject {

    private static final long serialVersionUID = 6496098798146410884L;

    private String doorState = "";// 表示门的状态，有“开”和“关”两种

    public DoorEvent(Object source, String doorState) {
        super(source);
        this.doorState = doorState;
    }

    public void setDoorState(String doorState) {
        this.doorState = doorState;
    }

    public String getDoorState() {
        return this.doorState;
    }

}
```
（2）定义新的事件监听接口，该接口继承自EventListener；该接口包含对doorEvent事件的处理程序：
```java
/**
* 定义监听接口，负责监听DoorEvent事件
*/
public interface DoorListener extends EventListener {
     public void doorEvent(DoorEvent event);
}
```
通过上面的接口我们再定义事件监听类，这些类具体实现了监听功能和事件处理功能。
```java
/**
* 该类为 门1监听接口的实现，做具体的开门，关门动作
*/
public class DoorListener1 implements DoorListener {
    @Override
    public void doorEvent(DoorEvent event) {
        // TODO Auto-generated method stub
        if (event.getDoorState() != null && event.getDoorState().equals("open")) {
            System.out.println("门1打开");
        } else {
            System.out.println("门1关闭");
        }
    }

}

/**
* 该类为 门2监听接口的实现，做具体的开门，关门，以及开灯，关灯动作
*/
public class DoorListener2 implements DoorListener {

    @Override
    public void doorEvent(DoorEvent event) {
        // TODO Auto-generated method stub
        if (event.getDoorState() != null && event.getDoorState().equals("open")) {
            System.out.println("门2打开，同时打开走廊的灯");
        } else {
            System.out.println("门2关闭，同时关闭走廊的灯");
        }
    }

}
```
（3）通过DoorManager.java创造一个事件源类，它用一个Collection listeners对象来存储所有的事件监听器对象，存储方式是通过addDoorListener(..)这样的方法。notifyListeners(..)是触发事件的方法，用来通知系统：事件发生了，你调用相应的处理函数吧。
```java
/**
* 事件源对象，在这里你可以把它想象成一个控制开门关门的遥控器，
* (如果是在swing中，就类似一个button)
*/
public class DoorManager {
    private Collection listeners;

    /**
     * 添加事件
     * 
     * @param listener
     *            DoorListener
     */
    public void addDoorListener(DoorListener listener) {
        if (listeners == null) {
            listeners = new HashSet();
        }
        listeners.add(listener);
    }

    /**
     * 移除事件
     * 
     * @param listener
     *            DoorListener
     */
    public void removeDoorListener(DoorListener listener) {
        if (listeners == null)
            return;
        listeners.remove(listener);
    }

    /**
     * 触发开门事件
     */
    protected void fireWorkspaceOpened() {
        if (listeners == null)
            return;
        DoorEvent event = new DoorEvent(this, "open");
        notifyListeners(event);
    }

    /**
     * 触发关门事件
     */
    protected void fireWorkspaceClosed() {
        if (listeners == null)
            return;
        DoorEvent event = new DoorEvent(this, "close");
        notifyListeners(event);
    }

    /**
     * 通知所有的DoorListener
     */
    private void notifyListeners(DoorEvent event) {
        Iterator iter = listeners.iterator();
        while (iter.hasNext()) {
            DoorListener listener = (DoorListener) iter.next();
            listener.doorEvent(event);
        }
    }
}
```
（4）好了，最后写一个测试程序测试一下我们自定义的事件吧，这段程序应该不难理解吧：）
```java
/**
* 主程序，就想象成要开门的哪个人
*/
public class DoorMain {
    public static void main(String[] args) {
        DoorManager manager = new DoorManager();
        manager.addDoorListener(new DoorListener1());// 给门1增加监听器
        manager.addDoorListener(new DoorListener2());// 给门2增加监听器
        // 开门
        manager.fireWorkspaceOpened();
        System.out.println("我已经进来了");
        // 关门
        manager.fireWorkspaceClosed();
    }
}
```
运行DoorMain
门1打开 
门2打开，同时打开走廊的灯
我已经进来了
门1关闭
门2关闭，同时关闭走廊的灯





