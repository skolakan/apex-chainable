public inherited sharing abstract class chain_Batch extends chain_Chainable implements Database.Batchable<sObject> {
  private Database.BatchableContext bc;
  private List<sObject> scope;

  public chain_Batch(){
    super();
  }

  protected override abstract void job();

  public abstract Database.QueryLocator start(Database.BatchableContext bc);

  public virtual void execute(Database.BatchableContext bd, List<sObject> scope){
    this.bc = bc;
    this.scope = scope;
    try {
      this.job();
    } catch(Exception ex) {
      if(this.canBreak == true) {
        throw ex;
      }
    }
  }

  public virtual void finish(Database.BatchableContext bc){
    this.chain();
  }

  public virtual override void executeChain() {
    Database.executeBatch(this);
  }

  public override chain_Chainable add(final chain_Chainable aChain) {
    if(!(aChain instanceof chain_Future)) {
      return super.add(aChain);
    }
    return this;
  }
}