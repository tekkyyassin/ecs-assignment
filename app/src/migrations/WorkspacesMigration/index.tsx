import { FC, ReactNode, useEffect } from "react";
import useLocalStorageState from "use-local-storage-state";
import { v4 as uuidv4 } from "uuid";
import { LOCAL_STORAGE_KEY_WORKSPACE_LIST_MIGRATION } from "../../configs/localStorageKeys";
import { useWorkspacesContext } from "../../contexts/WorkspacesContext/context";

export interface WorkspacesMigrationProps {
  children: ReactNode;
}

const WorkspacesMigration: FC<WorkspacesMigrationProps> = ({ children }) => {
  const { workspaceList, setWorkspaceList } = useWorkspacesContext();

  const [migrated, setMigrated] = useLocalStorageState<boolean>(
    LOCAL_STORAGE_KEY_WORKSPACE_LIST_MIGRATION,
    { defaultValue: false },
  );

  useEffect(() => {
    if (migrated) return;
    if (!workspaceList || workspaceList.length === 0) return;

    // Already migrated (new format)
    if (typeof workspaceList[0] !== "string") {
      setMigrated(true);
      return;
    }

    // Old format: string[]
    const newList = (workspaceList as unknown as string[]).map((name) => ({
      id: uuidv4(),
      name,
    }));

    setWorkspaceList(newList as any);
    setMigrated(true);
  }, [migrated, workspaceList, setWorkspaceList, setMigrated]);

  return migrated && children ? <>{children}</> : null;
};

export default WorkspacesMigration;
