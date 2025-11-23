"use client"

import dynamic from 'next/dynamic';
import React, { createContext, useContext, useState, ReactNode } from 'react';



interface TabContextType {
  currentTab: string;
  setCurrentTab: (tab: string) => void;
}

const TabContext = createContext<TabContextType | undefined>(undefined);

export const TabProvider = ({ children }: {children: ReactNode}) => {
  const [currentTab, setCurrentTab] = useState("add");

  return (
    <TabContext.Provider value={{ currentTab, setCurrentTab }} >
      {children}
    </TabContext.Provider>
  );
};

export const useTab = () => {
  const context = useContext(TabContext);
  if (context === undefined) {
    throw new Error('useTab must be used within a TabProvider');
  }
  return context;
};